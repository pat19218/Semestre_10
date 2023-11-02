# UART Control
#
# This example shows how to use the serial port on your OpenMV Cam. Attach pin
# P4 to the serial input of a serial LCD screen to see "Hello World!" printed
# on the serial LCD display.

import time
from pyb import UART

# Always pass UART 3 for the UART number for your OpenMV Cam.
# The second argument is the UART baud rate. For a more advanced UART control
# example see the BLE-Shield driver.
uart = UART(3, 115200)
#uart.init(9600, bits=8, parity=None, stop=1, timeout_char=1000) # init with given parameters
a = 12.2


while True:
    uart.write(str(a)+"\n")
    print(str(a))
    time.sleep_ms(1000)

    #msg = uart.read()
    #print(msg)
    #time.sleep_ms(500)
