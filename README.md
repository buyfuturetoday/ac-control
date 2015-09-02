# ac-control
Controls my air conditioner with a raspberry pi and a shitty USB temp sensor

It's probably not very useful unless you have the same shitty USB temp sensor that writes logs in CSV format, and a shitty air conditioner with only manual controls.

Run it with the argument "on" if the AC is on when the script starts, or "off" or no arguments if it's off.

For output, it produces a timestamp with the temperature every time it takes an action.  Otherwise, it outputs a character every time it checks the temperature:

* A dash (-) if the temperature is below 72F and the AC is already off
* A dot (.) if the temperature is between 72F and 77F, regardless of AC state
* A plus (+) if the temperature is above 77F and the AC is already running

If the temperature drops below 63 while the AC is off, or above 77.5 while the AC is on, the script assumes the shitty air conditioner failed to respond to a power cycle command and sends another one.

**<big>WARNING: This script relies on dangerous things, like the user your web server runs as having sudo permission.  Ensure that it's only run on a secure, properly firewalled network.</big>**
