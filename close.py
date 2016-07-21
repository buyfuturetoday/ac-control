#!/usr/bin/python
import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
statefile = "ventstate.html"

#print 'Switching on pin 8...\n'
GPIO.setup(11, GPIO.OUT)
GPIO.output(11, False)
time.sleep(1)
GPIO.output(11, True)
FILE = open(statefile,"w")
FILE.writelines("Vent is is <b>CLOSED</b>")
FILE.close()
print 'Done\n'
