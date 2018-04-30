#include "I2Cdev.h"
#include "MPU6050.h"

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#define CE_PIN   9
#define CSN_PIN 10

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

MPU6050 accelgyro;  // Create AccGyr
RF24 radio(CE_PIN, CSN_PIN); // Create a Radio
const uint64_t pipe = 0xE8E8F0F0E1LL; // Define the transmit pipe
int packet[6];
int16_t ax, ay, az;
int16_t gx, gy, gz;

#define LED_PIN 7
bool blinkState = false;




void setup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    accelgyro.initialize();

    radio.begin();
    radio.openWritingPipe(pipe);
   
    // configure Arduino LED for
    pinMode(LED_PIN, OUTPUT);
}



void loop() {
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    packet[0] = ax;
    packet[1] = ay;
    packet[2] = az;
    packet[3] = gx;
    packet[4] = gy;
    packet[5] = gz;

    radio.write(packet, sizeof(packet));

    
    if(ax != 0 && ay != 0 && az != 0)
    {
        // blink LED twice a second to indicate - activity
        blinkState = (millis()/500)%2 == 0;
        digitalWrite(LED_PIN, blinkState);    
    }
}
