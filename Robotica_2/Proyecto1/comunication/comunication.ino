
#include <Arduino.h>

// There are two ways to make this sketch work:
// By physically connecting the pins 16 and 17 and then create a physical UART loopback,
// Or by using the internal IO_MUX to connect the TX signal to the RX pin, creating the
// same loopback internally.

#define DATA_SIZE 26    // 26 bytes is a lower than RX FIFO size (127 bytes) 
#define BAUD 115200       // Any baudrate from 300 to 115200
#define TEST_UART 1     // Serial1 will be used for the loopback testing with different RX FIFO FULL values
#define RXPIN 16         // GPIO 16 => RX for Serial1
#define TXPIN 17         // GPIO 17 => TX for Serial1

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);      // set LED pin as output
  digitalWrite(LED_BUILTIN, LOW);    // switch off LED pin

  // UART1 will have its RX<->TX cross connected
  // GPIO16 <--> GPIO17 using external wire
  Serial.begin(115200);
  Serial1.begin(BAUD, SERIAL_8N1, RXPIN, TXPIN); // Rx = 16, Tx = 17 will work for ESP32, S2, S3 and C3

}  


void loop() {
  //Serial1.write("halo");
  //delay(600);

  if(Serial1.available()) {
    char a = Serial1.read();
    Serial.print(a);
  }
}


