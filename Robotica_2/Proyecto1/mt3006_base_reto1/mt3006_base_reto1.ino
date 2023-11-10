// ================================================================================
// Dependencias | librerías
// ================================================================================
#include <tinycbor.h>  // ***NO MODIFICAR***
// Puede agregar sus librerías a partir de este punto
#include <Arduino.h>
#include <SoftwareSerial.h>

SoftwareSerial mySerial(16, 17);
/*
#define DATA_SIZE 26  // 26 bytes is a lower than RX FIFO size (127 bytes)
#define BAUD 115200   // Any baudrate from 300 to 115200
#define TEST_UART 1   // Serial1 will be used for the loopback testing with different RX FIFO FULL values
#define RXPIN 16      // GPIO 16 => RX for Serial1
#define TXPIN 17      // GPIO 17 => TX for Serial1
*/
String x = "";
String y = "";

int pos_x = 0;
int pos_y = 0;

byte tread = 100;

byte centrox = 159;
byte centroy = 123;
byte errorx = 0;
byte errory = 0;

float kpv = 0.1;
float kpu = 0.1;
float v = 0;
float w = 0;
const float radio = 0.016;
const float distancia_centro = 0.047;


// ================================================================================
// Funcionamiento básico del robot, ***NO MODIFICAR***
// ================================================================================
uint8_t uart_send_buffer[32] = { 0 };             // buffer CBOR
static const unsigned int control_time_ms = 100;  // período de muestreo del control
volatile float phi_ell = 0;                       // en rpm
volatile float phi_r = 0;                         // en rpm

void encode_send_wheel_speeds_task(void* p_params) {
  TickType_t last_control_time;
  const TickType_t control_freq_ticks = pdMS_TO_TICKS(control_time_ms);

  // Tiempo actual
  last_control_time = xTaskGetTickCount();

  while (1) {
    // Se espera a que se cumpla el período de muestreo
    vTaskDelayUntil(&last_control_time, control_freq_ticks);

    TinyCBOR.Encoder.init(uart_send_buffer, sizeof(uart_send_buffer));
    TinyCBOR.Encoder.create_array(2);
    TinyCBOR.Encoder.encode_float(phi_ell);
    TinyCBOR.Encoder.encode_float(phi_r);
    TinyCBOR.Encoder.close_container();
    Serial2.write(TinyCBOR.Encoder.get_buffer(), TinyCBOR.Encoder.get_buffer_size());
  }
}
// ================================================================================


// ================================================================================
// Programar la funcionalidad de visual servoing aquí
// ================================================================================
void visual_servoing_task(void* p_params) {

  while (1)  // loop()
  {
    //Serial1.write("1");
    mySerial.write("1");
    //delay(tread);
    while (mySerial.available()) {
      char a = mySerial.read();

      if (a == 'x') {
        break;
      } else {
        x += a;
      }
    }

    //delay(tread);
    mySerial.write("2");
    while (mySerial.available()) {
      char a = mySerial.read();

      if (a == 'y') {
        break;
      } else {
        y += a;
      }
    }

    pos_x = x.toInt();
    pos_y = y.toInt();

    //Serial.print("Dato x: ");
    //Serial.println(pos_x);
    //Serial.print("Dato y :    ");
    //Serial.println(pos_y);

    x = "";
    y = "";

    errorx = pos_x - centrox;
    errory = pos_y - centroy;

    // control de posicion lineal

    v = kpv * errory;

    // control de posicion angular

    w = kpu * errorx;

    // calculo de velociades de ruedas

    phi_ell = (v - distancia_centro * w) / radio;
    phi_r = (v + distancia_centro * w) / radio;

    if (phi_ell >= 300.0) {
      phi_ell = 300.0;
    } else if (phi_ell <= -300.0) {
      phi_ell = -300.0;
    }

    if (phi_r >= 300.0) {
      phi_r = 300.0;
    } else if (phi_r <= -300.0) {
      phi_r = -300.0;
    }

    phi_r = -300.0;
    phi_ell = 300.0;

    //Serial.println("Hello");
    vTaskDelay(1000 / portTICK_PERIOD_MS);  // delay de 1 segundo (thread safe)
  }
}


void setup() {
  Serial.begin(115200);   // ***NO MODIFICAR***
  Serial2.begin(115200);  // ***NO MODIFICAR***
  TinyCBOR.init();        // ***NO MODIFICAR***

  // Si alguna de sus librerías requiere setup, colocarlo aquí
  //Serial1.begin(BAUD, SERIAL_8N1, RXPIN, TXPIN);  // Rx = 16, Tx = 17 will work for ESP32, S2, S3 and C3
  mySerial.begin(115200);

  // Creación de tasks ***NO MODIFICAR***
  xTaskCreate(encode_send_wheel_speeds_task, "encode_send_wheel_speeds_task", 1024 * 2, NULL, configMAX_PRIORITIES, NULL);
  xTaskCreate(visual_servoing_task, "visual_servoing_task", 1024 * 2, NULL, configMAX_PRIORITIES - 1, NULL);
}


void loop() {
}
