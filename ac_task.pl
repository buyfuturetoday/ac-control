#	ac_task.pl
#	Skylar Gasai / https://github.com/YandereSkylar/ac-control
#
#	Reads the temperature from a log file, checks it against configured maximum, runs AC if needed
#	This script is designed to be run as a Windows scheduled task
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

my $wcommand = '"C:\\Program Files (x86)\\GnuWin32\\bin\\ls.exe" -1 --sort=time C:\\log';
my @raw = qx/$wcommand/;
$raw[0] =~ s/\n//;
my $command = '"C:\\Program Files (x86)\\GnuWin32\\bin\\tail.exe" "C:\\log\\' . $raw[0] . '" -n 1';
my @lines = qx/$command/;
$lines[0] =~ s/\n//;
$lines[0] =~ m%,(.*?),%s;
my $temp = $1;
if ($temp >= 75) {
	my $ua = LWP::UserAgent->new;
	$ua->timeout(8);
	$ua->env_proxy;
	$ua->max_redirect(0);
	$ua->agent('Mozilla/5.0+(Windows+NT+6.2;+WOW64;+rv:28.0)+Gecko/20100101+Firefox/28.0');
	my $maxsize = (1024 * 1024 * 4);
	$ua->max_size($maxsize);
	$ua->get("http://server.example.com/ac.php?on=1");
	my $datestring = localtime();
	open (logfile, ">>", "C:\\path\\to\\ac.log");
	print logfile $datestring . " - " . 'Temperature too high (' . $temp . '), ran air conditioner for 40 minutes';
	print logfile "\n";
	close logfile;
	sleep(60 * 40);	# minimum run time of 40 minutes
	$ua->get("http://server.example.com/ac.php?off=1");
} else {
	die("Temperature " . $temp . " is below safe maximum.");
}