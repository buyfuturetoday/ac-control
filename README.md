# ac-control
Controls my air conditioner with my raspberry pi and a digital temperature sensor.  Also controls a motorized air vent with another temperature sensor for a kind of homemade zoned system.

ac_task.pl goes on the machine with the temp sensor and gets ran by a scheduled task

ac.php, on.py, and off.py go on the raspberry pi in the web server's directory

## Dependencies for AC control
* Perl with module LWP::Simple
* Python with RPi.GPIO
* PHP
* A temp sensor that can return data in a useful format
* A relay rated for 24VAC between your raspberry pi's GPIO pins and your air conditioner
* An air conditioner that can be switched on by connecting two wires (probably the Y and R or Rc)

## Dependencies for vent control
* Perl
* Python with RPi.GPIO
* PHP, if you intend to make it available over the web server
* An electronic air vent controlled by sending DC voltage in one direction to open and the other to close

![Circuit diagram](https://raw.githubusercontent.com/YandereSkylar/ac-control/master/circuit.png)

**<big>WARNING: This script relies on dangerous things, like the user your web server runs as having sudo permission.  I take no responsibility if you do something stupid and get your pi hacked, or break your air conditioner.</big>**
