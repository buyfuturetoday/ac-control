#!/usr/bin/perl
use warnings;
use strict;

# Get set point
my @sp = qx/cat setpoint/;
chomp($sp[0]);
print "Set point is " . $sp[0] . "F\n";

# Get mode
my @mode = qx/cat mode/;
chomp($mode[0]);
if ($mode[0] =~ /cool/) {
	print "Cooling mode: run air conditioner\n";
} elsif ($mode[0] =~ /heat/) {
	print "Heating mode: run furnace\n";
}

# Check current temperature & humidity
my @output = qx/python room.py/;
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
print "Room is at " . $f . "F (" . $c . "C) with " . $h . "% humidity\n";

# Check vent state
my @ventstate = qx/cat ventstate.html/;
if ($ventstate[0] =~ /OPEN/) {
	print "Air vent is open\n";
} elsif ($ventstate[0] =~ /CLOSED/) {
	print "Air vent is closed\n";
} else {
	die "Can't get vent state\n";
}

# Make decisions
if ($f < ($sp[0] - 0.5)) {
	print "Half a degree (or more) below set point, too cold\n";
	if ($mode[0] =~ /cool/) {
		if ($ventstate[0] =~ /CLOSED/) {
			print "Air vent already closed, nothing to do\n";
		} elsif ($ventstate[0] =~ /OPEN/) {
			print "Air vent is open, closing it\n";
			system("python close.py");
		}
	} elsif ($mode[0] =~ /heat/) {
		if ($ventstate[0] =~ /CLOSED/) {
			print "Air vent is closed, opening it\n";
			system("python open.py");
		} elsif ($ventstate[0] =~ /OPEN/) {
			if ($f > ($sp[0] - 1.5)) {
				print "Air vent is already open, but it's 2 degrees (or more) below set point.  Starting furnace.\n";
				system("python heat_on.py");
			} else {
				print "Air vent is already open, nothing to do\n";
			}
		}
	}
} elsif ($f > ($sp[0])) {
	print "At or above set point\n";
	if ($mode[0] =~ /cool/) {
		if ($ventstate[0] =~ /OPEN/) {
			if ($f > ($sp[0] + 1)) {
				print "Air vent is already open, but it's 1 degree (or more) above set point.  Starting AC.\n";
				system("python run.py > /dev/null 2>&1 &");
			} else {
				print "Air vent is already open, nothing to do\n";
			}
		} elsif ($ventstate[0] =~ /CLOSED/) {
			print "Air vent is closed, opening it\n";
			system("python open.py");
		}
	} elsif ($mode[0] =~ /heat/) {
		print "Stopping any furnace run jobs in progress\n";
		system("python heat_off.py");
		if ($f > ($sp[0] + 0.5)) {
			print "Air vent is open, closing it\n";
			system("python close.py");
		}
	}
} else {
	print "Temperature is okay, taking no action\n";
}