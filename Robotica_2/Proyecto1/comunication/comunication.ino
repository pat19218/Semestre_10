
#include <Arduino.h>

// There are two ways to make this sketch work:
// By physically connecting the pins 16 and 17 and then create a physical UART loopback,
// Or by using the internal IO_MUX to connect the TX signal to the RX pin, creating the
// same loopback internally.
#define USE_INTERNAL_PIN_LOOPBACK 0   // 1 uses the internal loopback, 0 for wiring pins 4 and 5 externally

#define DATA_SIZE 26    // 26 bytes is a lower than RX FIFO size (127 bytes) 
#define BAUD 9600       // Any baudrate from 300 to 115200
#define TEST_UART 1     // Serial1 will be used for the loopback testing with different RX FIFO FULL values
#define RXPIN 16         // GPIO 16 => RX for Serial1
#define TXPIN 17         // GPIO 17 => TX for Serial1

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);      // set LED pin as output
  digitalWrite(LED_BUILTIN, LOW);    // switch off LED pin

  Serial2.begin(9600);            // initialize UART with the second board with baud rate of 9600
  
}

void loop() {
  Serial2.println('3');
  delay(100);
}


