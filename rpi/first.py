import RPi.GPIO as gpio
import picamera
import time
from smbus2 import SMBus
from mlx90614 import MLX90614
shop_id = ''
GPIO.setmode(GPIO.BOARD)
GPIO.setup(40,GPIO.OUT)
GPIO.setup(16,GPIO.IN)
pwm = GPIO.PWM(40,50)
pwm.start(5)
pwm.ChangeDutyCycle(2)
def cfa(y):
    return y/18 + 2
def detect_hand():#returns the value of ir sensor
    return GPIO.input(16)
def get_Temperature():
    bus = SMBus(1)
    sensor = MLX90614(bus, address=0x5A)
    print "Ambient Temperature :", sensor.get_ambient()
    print "Object Temperature :", sensor.get_object_1()
    temp = sensor.get_object_1()
    bus.close()
    return temp  
def run_dispencer():
    pwm2.ChangeDutyCycle(cfa(90))
    time.sleep(1)
    pwm2.ChangeDutyCycle(cfa(0))

