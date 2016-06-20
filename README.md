# ac-control
Controls my air conditioner with my raspberry pi and my shitty USB temp sensor

ac_task.pl goes on the machine with the temp sensor and gets ran by a scheduled task

ac.php, on.py, and off.py go on the raspberry pi in the web server's directory

## Dependencies
* Perl with module LWP::Simple
* Python with RPi.GPIO
* PHP
* A temp sensor that writes logs in a usable format
* A relay rated for 24VAC between your raspberry pi's GPIO pins and your air conditioner
* An air conditioner that can be switched on by connecting two wires (probably the Y and R or Rc)

**<big>WARNING: This script relies on dangerous things, like the user your web server runs as having sudo permission.  I take no responsibility if you do something stupid and get your pi hacked, or break your air conditioner.</big>**
