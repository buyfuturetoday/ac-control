#!/usr/bin/python
import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
statefile = "ventstate.html"

#print 'Switching on pin 8...\n'
GPIO.setup(7, GPIO.OUT)
GPIO.output(7, False)
time.sleep(1)
GPIO.output(7, True)
FILE = open(statefile,"w")
FILE.writelines("Vent is is <span style='color:blue'><b>OPEN</b></span>")
FILE.close()
print 'Done\n'
