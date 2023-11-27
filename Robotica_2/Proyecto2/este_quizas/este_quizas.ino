// ================================================================================
// Dependencias | librerías
// ================================================================================
#include <WiFi.h>
// Puede agregar sus librerías a partir de este punto

#include <Arduino.h>
#include <SoftwareSerial.h>

SoftwareSerial mySerial(26, 25);  // (rx, tx)

String str_id = "";
String str_tx = "";
String str_ty = "";
String str_tz = "";
String str_rx = "";
String str_ry = "";
String str_rz = "";

float data_id = 0;
float data_tx = 0;
float data_ty = 0;
float data_tz = 0;
float data_rx = 0;
float data_ry = 0;
float data_rz = 0;

// ================================================================================
// Funcionamiento básico del robot, ***NO MODIFICAR***
// ================================================================================
// WiFi + TCP
const char* ssid = "Robotat";
const char* password = "iemtbmcit116";
WiFiServer wifiServer(8888);
volatile char jsonstr[512];
volatile bool b_send_apriltag = false;
volatile unsigned tag_id = 0;
volatile float tag_x = 0, tag_y = 0, tag_z = 0;
volatile float tag_rotx = 0, tag_roty = 0, tag_rotz = 0;

void tcp_comms_task(void* p_params) {
  size_t jsonstr_len;

  while (1) {
    WiFiClient client = wifiServer.available();

    if (client) {
      while (client.connected()) {
        while (client.available() > 0) {
          char c = client.read();
          Serial2.write(c);
        }

        if (b_send_apriltag) {
          jsonstr_len = sprintf((char*)jsonstr, "{\"id\":%u,\"x\":%f,\"y\":%f,\"z\":%f,\"rotx\":%f,\"roty\":%f,\"rotz\":%f}",
                                tag_id, tag_x, tag_y, tag_z, tag_rotx, tag_roty, tag_rotz);
          //Serial.println((char *)jsonstr);
          client.println((char*)jsonstr);
          //client.write_P((char *)jsonstr, jsonstr_len + 1);
          b_send_apriltag = false;
        }

        vTaskDelay(10 / portTICK_PERIOD_MS);
      }
      client.stop();
      Serial.println("Client disconnected");
    }
    vTaskDelay(10 / portTICK_PERIOD_MS);
  }
}

void send_apriltag(unsigned id, float x, float y, float z, float rotx, float roty, float rotz) {
  if (!b_send_apriltag) {
    tag_id = id;
    tag_x = x;
    tag_y = y;
    tag_z = z;
    tag_rotx = rotx;
    tag_roty = roty;
    tag_rotz = rotz;
    b_send_apriltag = true;
  }
}
// ================================================================================


// ================================================================================
// Programar la interacción con la cámara y MATLAB aquí
// ================================================================================
void camera_task(void* p_params) {

  while (1)  // loop()
  {
    //           id   x       y    z     rotx    roty  rotz
    //send_apriltag(2, 1.23, -5.69, 0.36, 0.256, -0.369, -1.1);  // ejemplo de cómo enviar la información de los tags
    //vTaskDelay(100 / portTICK_PERIOD_MS);                      // delay de 10 segundos (thread safe)


    //----------------------------------------------------------------------------
    //                Nosotros
    //----------------------------------------------------------------------------
    mySerial.write("A");
    vTaskDelay(30 / portTICK_PERIOD_MS);
    if (mySerial.available()) {
      String aja = mySerial.readString();
      //Serial.println(aja);
      byte index_1 = 0;
      for (byte i = 97; i <= 103; i++) {
        byte index = aja.indexOf(i);
        switch (i) {
          case 97:
            str_id = aja.substring(1, index);
            break;
          case 98:
            str_tx = aja.substring(index_1, index);
            break;
          case 99:
            str_ty = aja.substring(index_1, index);
            break;
          case 100:
            str_tz = aja.substring(index_1, index);
            break;
          case 101:
            str_rx = aja.substring(index_1, index);
            break;
          case 102:
            str_ry = aja.substring(index_1, index);
            break;
          case 103:
            str_rz = aja.substring(index_1, index);
            break;
        }
        index_1 = index + 1;
        //Serial.println(sub_S);
      }
      /*
      byte index = aja.indexOf('a');
      String sub_S = aja.substring(1, index);
      Serial.println(sub_S);
      */

      // impresion de valores del Json recibido

      Serial.println(str_id);
      Serial.print("      ");
      Serial.println(str_tx);
      Serial.print("      ");
      Serial.println(str_ty);
      Serial.print("             ");
      Serial.println(str_tz);
      Serial.print("                  ");
      Serial.println(str_rx);
      Serial.print("                       ");
      Serial.println(str_ry);
      Serial.print("                          ");
      Serial.println(str_rz);

      try {
        data_id = str_id.toFloat();
        data_tx = str_tx.toFloat();
        data_ty = str_ty.toFloat();
        data_tz = str_tz.toFloat();
        data_rx = str_rx.toFloat();
        data_ry = str_ry.toFloat();
        data_rz = str_rz.toFloat();

        Serial.println(data_id);
        Serial.println(data_tx);
        Serial.println(data_ty);
        Serial.println(data_tz);
        Serial.println(data_rx);
        Serial.println(data_ry);
        Serial.println(data_rz);

        send_apriltag(data_id, data_tx, data_ty, data_tz, data_rx, data_ry, data_rz);

      } catch (...) {
      }
    }

  }  // fin loop general
}


void setup() {
  // ================================================================================
  // Setup del robot, ***NO MODIFICAR***
  // ================================================================================
  Serial.begin(115200);
  Serial2.begin(115200);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }

  Serial.println("Connected to the WiFi network");
  Serial.println(WiFi.localIP());

  wifiServer.begin();
  // ================================================================================

  // Si alguna de sus librerías requiere setup, colocarlo aquí
  mySerial.begin(115200);

  // Creación de tasks ***NO MODIFICAR***
  xTaskCreate(tcp_comms_task, "tcp_comms_task", 1024 * 2, NULL, configMAX_PRIORITIES, NULL);
  xTaskCreate(camera_task, "camera_task", 1024 * 2, NULL, configMAX_PRIORITIES - 1, NULL);
}


void loop() {
}
