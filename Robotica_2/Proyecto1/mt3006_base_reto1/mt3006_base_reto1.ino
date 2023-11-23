// ================================================================================
// Dependencias | librerías
// ================================================================================
#include <tinycbor.h>  // **NO MODIFICAR**
// Puede agregar sus librerías a partir de este punto
#include <Arduino.h>
#include <SoftwareSerial.h>

SoftwareSerial mySerial(26, 25);

// ================================================================================
// Funcionamiento básico del robot, **NO MODIFICAR**
// ================================================================================
uint8_t uart_send_buffer[32] = { 0 };             // buffer CBOR
static const unsigned int control_time_ms = 100;  // período de muestreo del control
volatile float phi_ell = 0;                       // en rpm
volatile float phi_r = 0;                         // en rpm
const int DISTANCE_FROM_CENTER{ 95 / 2 };
const int WHEEL_RADIUS{ 32 / 2 };


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

    float valor_x{};
    float valor_y{};
    bool bandera{};

    String Temp{};
    //320 x 240 resolucion de camara
    if (mySerial.available() > 0) {
      Temp = mySerial.readStringUntil(';');

      bandera = 1;
    }

    if (bandera) {
      String temp2 = Temp.substring(Temp.indexOf("X") + 1, Temp.indexOf("Y"));
      valor_x = temp2.toFloat() - (320 / 2);                             // calculo de error en X

      temp2 = Temp.substring(Temp.indexOf("Y") + 1, Temp.length());     // calculo de error en Y
      valor_y = ((temp2.toFloat())/100) - (240/ 2);

      bandera = 0;

      /*Serial.println(valor_x);
      Serial.println("   ");
      Serial.println(valor_y);
      */

      float v{ -5*(0 + valor_y)};
      float w{ (0 + valor_x) / 10 };  // aplicación de controlador

      phi_ell = (v + w * DISTANCE_FROM_CENTER) / WHEEL_RADIUS;
      phi_r = (v - w * DISTANCE_FROM_CENTER) / WHEEL_RADIUS;   // calculo de velocidades de cada rueda

      if (phi_ell > 50.0) {
        phi_ell = 50.0;
      } else if (phi_ell < -50.0) {      // limites de velocidades de ruedas
        phi_ell = -50.0;
      }

      if (phi_r > 50.0) {
        phi_r = 50.0;
      } else if (phi_r < -50.0) {        // limites de velocidades de ruedas
        phi_r = -50.0;
      }

      Serial.println(phi_ell);
      Serial.print("            ");       // para comprobar que se imprima bien
      Serial.println(phi_r);


    } else {
      // phi_ell = 0;
      //phi_r = 0;
    }
  }
}


void setup() {
  Serial.begin(115200);   // **NO MODIFICAR**
  Serial2.begin(115200);  // **NO MODIFICAR**
  TinyCBOR.init();        // **NO MODIFICAR**
  mySerial.begin(115200);

  // Si alguna de sus librerías requiere setup, colocarlo aquí

  // Creación de tasks **NO MODIFICAR**
  xTaskCreate(encode_send_wheel_speeds_task, "encode_send_wheel_speeds_task", 1024 * 2, NULL, configMAX_PRIORITIES, NULL);
  xTaskCreate(visual_servoing_task, "visual_servoing_task", 1024 * 2, NULL, configMAX_PRIORITIES - 1, NULL);
}


void loop() {
}