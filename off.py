#!/usr/bin/python
import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
statefile = "acstate.html"

GPIO.setup(13, GPIO.OUT)

GPIO.output(13, True)
FILE = open(statefile,"w")
FILE.writelines("AC manual override is <b>OFF</b>")
FILE.close()
print 'Done\n'
