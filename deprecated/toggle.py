#!/usr/bin/python
import RPi.GPIO as GPIO
import time

GPIO.setup(15, GPIO.OUT)

GPIO.output(15, False)
time.sleep(3)

GPIO.output(15, True)
print 'Relay has been toggled\n'
