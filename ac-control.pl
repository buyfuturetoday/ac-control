#	ac-control
# 	version 0.0.1
#	Skylar Akemi / https://github.com/homura/ac-control
#	Get temperature from USB sensor, cycle AC accordingly
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
use LWP::Simple;
use Time::HiRes;
our $powerstate;

$state = $ARGV[0];
if (!$state) {
	my $datestring = localtime();
	$powerstate = 0;	# Assume it's off unless otherwise given
	print "$datestring - No power state given, assuming OFF\n";
} elsif ($state =~ "off") {
	my $datestring = localtime();
	$powerstate = 0;
	print "$datestring - Power state specified as OFF\n";
} elsif ($state =~ "on") {
	my $datestring = localtime();
	$powerstate = 1;
	print "$datestring - Power state specified as ON\n";
}
#our $powerstate = 1;	# Assume the AC is running when the script is started

while (1) {
	my $wcommand = 'ls -1 --sort=time /path/to/logfiles/';
	my @logfiles = qx/$wcommand/;
	$logfiles[0] =~ s/\n//;
	my $command = 'tail "/path/to/logfiles/' . $logfiles[0] . '" -n 1';
	my @rawline = qx/$command/;
	$rawline[0] =~ s/\n//;
	$rawline[0] =~ m%,(.*?),%s;
	my $temp = $1;
	my $datestring = localtime();

	if ($temp < '72') {
		if ($powerstate) {
			# Cold enough, shut it down
			print "\n$datestring - $temp F - Stopping AC\n";
			cycle();
			$powerstate = 0;
			sleep(60 * 4);  # Minimum rest time of 5 minutes
		} elsif ($temp < '63') {
			print "\n$datestring - $temp F - Script may have failed, state unknown, cycling OFF?\n";
			cycle();
			$powerstate = 0;
			sleep(60 * 4);  # Minimum rest time of 5 minutes
		} else {
			#print "$datestring - $temp F - AC already appears OFF\n";
			print "-";
		}
	} elsif ($temp > '77') {
		if (!$powerstate) {
			# 2hot5me, start the AC
			print "\n$datestring - $temp F - Starting AC\n";
			cycle();
			$powerstate = 1;
			sleep(60 * 19);  # Minimum run time of 20 minutes
		} elsif ($temp > '77.5') {
			print "\n$datestring - $temp F - Script may have failed, state unknown, cycling ON?\n";
			cycle();
			$powerstate = 1;
			sleep(60 * 19);  # Minimum run time of 20 minutes
		} else {
			#print "$datestring - $temp F - AC already appears ON\n";
			print "+";
		}
	} else {
		# Temp is ok, keep doing whatever it was doing before
		#print "$datestring - $temp F\n";
		print ".";
	}
	sleep(60);  # Wait 1 minute before measuring again
}

sub cycle {
	my $ua = LWP::UserAgent->new;
	$ua->timeout(6);
	$ua->env_proxy;
	$ua->max_redirect(0);
	my $maxsize = (1024 * 1024 * 4);
	$ua->max_size($maxsize);
	my $url = 'http://server.example.com/toggle.php';
	my $response = $ua->get($url);
}