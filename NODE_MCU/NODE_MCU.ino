#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <MFRC522.h>
#include <SPI.h>

const char* ssid = "NK iPad";
const char* password = "12345678";

#define SS_PIN D4  //--> SDA / SS is connected to pinout D2
#define RST_PIN D3 
#define tone_PIN D2 //--> RST is connected to pinout D1
MFRC522 mfrc522(SS_PIN, RST_PIN);  //--> Create MFRC522 instance.

ESP8266WebServer server(80); 
WiFiClient wifiClient;

int readsuccess;
byte readcard[4];
char str[32] = "";
String StrUID;


void setup() {
  pinMode(tone_PIN, OUTPUT);
  Serial.begin(57600); //--> Initialize serial communications with the PC
  SPI.begin(); 
  mfrc522.PCD_Init(); //--> Init MFRC522 card

  delay(500);

  //WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password); //--> Connect to your WiFi router
  Serial.println("");

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Successfully connected to : ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  

}

void loop() {
  
    
    readsuccess = getid();
    String UIDresultSend, postData;
    UIDresultSend = StrUID;
    
    if (readsuccess) {
     

        //Post Data
        postData = "UIDresult=" + UIDresultSend;
        
        HTTPClient http;
        http.begin(wifiClient,"http://172.20.10.3:8020/api/cardUID");  //Specify request destination
        http.addHeader("Content-Type", "application/x-www-form-urlencoded"); //Specify content-type header

        int httpCode = http.POST(postData);   //Send the request
        String payload = http.getString();    //Get the response payload

        Serial.println(httpCode);   //Print HTTP return code
        Serial.println(payload);    //Print request response payload

        if(payload == "0"){
          tone(tone_PIN, 280, 1200);
        }

        http.end();  //Close connection
      
    }
   
    

}

int getid() {
  if (!mfrc522.PICC_IsNewCardPresent()) {
    return 0;
  }
  if (!mfrc522.PICC_ReadCardSerial()) {
    return 0;
  }


  Serial.print("THE UID OF THE SCANNED CARD IS : ");

  for (int i = 0; i < 4; i++) {
    readcard[i] = mfrc522.uid.uidByte[i]; //storing the UID of the tag in readcard
    array_to_string(readcard, 4, str);
    StrUID = str;
  }
  mfrc522.PICC_HaltA();
  return 1;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//----------------------------------------Procedure to change the result of reading an array UID into a string------------------------------------------------------------------------------//
void array_to_string(byte array[], unsigned int len, char buffer[]) {
  for (unsigned int i = 0; i < len; i++)
  {
    byte nib1 = (array[i] >> 4) & 0x0F;
    byte nib2 = (array[i] >> 0) & 0x0F;
    buffer[i * 2 + 0] = nib1  < 0xA ? '0' + nib1  : 'A' + nib1  - 0xA;
    buffer[i * 2 + 1] = nib2  < 0xA ? '0' + nib2  : 'A' + nib2  - 0xA;
  }
  buffer[len * 2] = '\0';
}
