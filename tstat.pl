#!/usr/bin/perl
#	tstat.pl
#	Skylar Gasai \ skylar@yandere.love \ https://github.com/YandereSkylar/ac-control
#
#	Main thermostat program: reads temperature, does things
#
#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
use warnings;
use strict;

# Set default thresholds
my $toocold = 2;
my $toohot = 1.5;

# Apply schedule
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
print "Hour is: " . $hour . "\n";
if ($hour >= 22) {
	$toohot = 7.5;
	print "Sleep mode: scheduled set point 68\n";
	system("echo 68 > /srv/www/setpoint");
} elsif ($hour >= 17) {
	print "Evening mode: scheduled set point 74\n";
	system("echo 74 > /srv/www/setpoint");
} elsif ($hour >= 10) {
	print "Day mode: scheduled set point 75\n";
	system("echo 75 > /srv/www/setpoint");
}

# Get set point
my @sp = qx/cat \/srv\/www\/setpoint/;
chomp($sp[0]);
print "Set point is " . $sp[0] . "F\n";

# Check if house is occupied
use Net::Ping;
my $away = 0;
my $count = 0;
while ($count < 3) {
	my $p = Net::Ping->new("icmp", 5);
	if ($p->ping("dns.name.of.smartphone.yourdomain.tld", 2)) {
		$count = 99;
		$away = 0;
		print "Phone responded, house occupied, enforcing temperatures as normal.\n";
	} else {
		$count++;
		$away = 1;
	}
}
if ($away) {
	$toocold = 10;
	$toohot = (79 - $sp[0]);
	print "Away mode: relaxing temperatures, too cold @ " . ($sp[0] - $toocold) . "F, too hot @ " . ($sp[0] + $toohot) . "F\n";
}

# Get mode
my @mode = qx/cat \/srv\/www\/mode/;
chomp($mode[0]);
if ($mode[0] =~ /cool/) {
	print "Cooling mode: run air conditioner, too hot @ " . ($sp[0] + $toohot) . "F\n";
} elsif ($mode[0] =~ /heat/) {
	print "Heating mode: run furnace, too cold @ " . ($sp[0] - $toocold) . "F\n";
} elsif ($mode[0] =~ /off/) {
	print "Off mode: fan only\n";
} elsif ($mode[0] =~ /both/) {
	print "Both mode: keep house comfy, too cold @ " . ($sp[0] - $toocold) . "F, too hot @ " . ($sp[0] + $toohot) . "F\n";
}
# Check current temperature & humidity
my @output = qx/python \/srv\/www\/room.py/;
my $f;
my $c;
my $h;
foreach (@output) {
	if ($_ =~ /Failed/) {
		die "Failed to get temperature.  Check cable or try again\n";
	}
	if ($_ =~ /Temp=/) {
		$_ =~ m/Temp=(\d{2}\.\d)\*C\s(\d{2}\.\d)\*F\sHumidity=(\d{2}\.\d)%/;
		$c = $1;
		$f = $2;
		$h = $3;
	}
}
if (!$f) {
	die "Failed to get temperature.  Check cable or try again\n";
}
print "Room is at " . $f . "F (" . $c . "C) with " . $h . "% humidity\n";

# Check vent state
my @ventstate = qx/cat \/srv\/www\/ventstate.html/;
if ($ventstate[0] =~ /OPEN/) {
	print "Air vent is open\n";
} elsif ($ventstate[0] =~ /CLOSED/) {
	print "Air vent is closed\n";
} else {
	die "Can't get vent state\n";
}

# Make decisions
if ($f < ($sp[0])) {
	print "Below set point, too cold\n";
	if ($mode[0] =~ /cool/) {
		print "Stopping any AC run jobs in progress\n";
		system("python /srv/www/device4/off.py");
		if ($ventstate[0] =~ /CLOSED/) {
			print "Air vent already closed, nothing to do\n";
		} elsif ($ventstate[0] =~ /OPEN/) {
			print "Air vent is open, closing it\n";
			system("python /srv/www/device2/close.py");
		}
	} elsif ($mode[0] =~ /heat/) {
		if ($ventstate[0] =~ /CLOSED/) {
			print "Air vent is closed, opening it\n";
			system("python /srv/www/device1/open.py");
		}
		if ($f < ($sp[0] - $toocold)) {
			print "Air vent is already open, but it's below " . ($sp[0] - $toocold) . "F.  Starting furnace.\n";
			system("python /srv/www/device3/on.py");
		} elsif ($f > ($sp[0] - 0.5)) {
			print "It's within .5 degrees below set point.  Stopping furnace.\n";
			system("python /srv/www/device3/off.py");
		}
	} elsif ($mode[0] =~ /both/) {
		print "Stopping any AC run jobs in progress\n";
		system("python /srv/www/device4/off.py");
		if ($ventstate[0] =~ /CLOSED/) {
			print "Air vent is closed, opening it\n";
			system("python /srv/www/device1/open.py");
		}
		if ($f < ($sp[0] - $toocold)) {
			print "It's below " . ($sp[0] - $toocold) . "F.  Starting furnace.\n";
			system("python /srv/www/device3/on.py");
		} elsif ($f > ($sp[0] - 0.5)) {
			print "It's within .5 degrees below set point.  Stopping furnace.\n";
			system("python /srv/www/device3/off.py");
		}
	}
} elsif ($f >= ($sp[0])) {
	print "At or above set point\n";
	if ($mode[0] =~ /cool/) {
		if ($f > ($sp[0] + $toohot)) {
			if ($ventstate[0] =~ /OPEN/) {
				print "Air vent is already open, but it's above " . ($sp[0] + $toohot) . "F.  Starting AC.\n";
				system("python /srv/www/device4/on.py");
			} else {
				system("python /srv/www/device1/open.py");
				system("python /srv/www/device4/on.py");
				print "Air vent is closed, and it's above " . ($sp[0] + $toohot) . "F.  Opening it & starting AC.\n";
			}
		} elsif ($ventstate[0] =~ /CLOSED/) {
			print "Air vent is closed, opening it\n";
			system("python /srv/www/device1/open.py");
		}
	} elsif ($mode[0] =~ /heat/) {
		print "Stopping any furnace run jobs in progress\n";
		system("python /srv/www/device3/off.py");
		# if ($f > ($sp[0] + 0.5)) {
		# 	print "Air vent is open, closing it\n";
		# 	system("python /srv/www/device2/close.py");
		# }
	} elsif ($mode[0] =~ /both/) {
		if ($ventstate[0] =~ /CLOSED/) {
			print "Air vent is closed, opening it\n";
			system("python /srv/www/device1/open.py");
		}
		print "Stopping any furnace run jobs in progress\n";
		system("python /srv/www/device3/off.py");
		if ($f >= ($sp[0] + $toohot)) {
			print "It's above " . ($sp[0] + $toohot) . "F.  Starting AC.\n";
			system("python /srv/www/device4/on.py");
		} elsif ($f <= ($sp[0] + 0.25)) {
			print "It's almost reached the set point.  Stopping AC.\n";
			system("python /srv/www/device4/off.py");
		}
	}
} else {
	print "Temperature is perfect, doing nothing.\n";
}
