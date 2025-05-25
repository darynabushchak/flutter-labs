#include <ESP8266WiFi.h>
#include <EEPROM.h>
#include <ESP8266WebServer.h>

const char* ssid = "darynka";
const char* password = "87654321";

const char* validUsername = "admin";
const char* validPassword = "1234";

ESP8266WebServer server(80);
String serialNumber = "undefined";

String readSerialFromEEPROM() {
  char value[64];
  int i = 0;
  while (true) {
    char c = EEPROM.read(i);
    if (c == '\0' || i >= 63) break;
    value[i++] = c;
  }
  value[i] = '\0';
  return String(value);
}

void writeSerialToEEPROM(const String& serial) {
  for (int i = 0; i < serial.length(); ++i) {
    EEPROM.write(i, serial[i]);
  }
  EEPROM.write(serial.length(), '\0'); // Terminate string
  EEPROM.commit();
}

void handleReadSerial() {
  serialNumber = readSerialFromEEPROM();
  server.send(200, "application/json", "{\"status\":\"OK\", \"serial_number\":\"" + serialNumber + "\"}");
}

void handleWriteSerial() {
  String username = server.arg("username");
  String password = server.arg("password");
  String newSerial = server.arg("serial");

  if (username != validUsername || password != validPassword) {
    server.send(401, "application/json", "{\"status\":\"ERROR\", \"message\":\"Invalid credentials\"}");
    return;
  }

  if (newSerial.length() > 0) {
    writeSerialToEEPROM(newSerial);
    server.send(200, "application/json", "{\"status\":\"OK\", \"message\":\"Serial updated\"}");
  } else {
    server.send(400, "application/json", "{\"status\":\"ERROR\", \"message\":\"Missing serial number\"}");
  }
}

void setup() {
  Serial.begin(9600);
  EEPROM.begin(512);
  WiFi.begin(ssid, password);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnected. IP: " + WiFi.localIP().toString());

  server.on("/read_serial", handleReadSerial);
  server.on("/write_serial", handleWriteSerial);

  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient();
}
