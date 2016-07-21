#!/usr/bin/python
import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
statefile = "acstate.html"

#print 'Switching on pin 8...\n'
GPIO.setup(13, GPIO.OUT)

GPIO.output(13, False)
FILE = open(statefile,"w")
FILE.writelines("AC manual override is <span style='color:blue'><b>ON</b></span>")
FILE.close()
print 'Running~\n'
time.sleep(60 * 25)
GPIO.output(13, True)
FILE = open(statefile,"w")
FILE.writelines("AC manual override is <b>OFF</b>")
FILE.close()
print 'Finished~\n'