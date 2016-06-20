#!/usr/bin/python
import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
statefile = "acstate.html"

GPIO.setup(13, GPIO.OUT)

GPIO.output(13, False)
FILE = open(statefile,"w")
FILE.writelines("AC manual override is <span style='color:blue'><b>ON</b></span>")
FILE.close()
print 'Done\n'
