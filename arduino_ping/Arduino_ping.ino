//=================================================================//
//============================= INITIT ============================//
//=================================================================// 

//=======================================================//
//========================= PING ========================//
//=======================================================// 
#include <NewPing.h>

#define SONAR_NUM     8 // Number or sensors.
#define MAX_DISTANCE 200 // Maximum distance (in cm) to ping.
#define PING_INTERVAL 30 // Milliseconds between sensor pings (29ms is about the min to avoid cross-sensor echo).

unsigned long pingTimer[SONAR_NUM]; // Holds the times when the next ping should happen for each sensor.
unsigned int cm[SONAR_NUM];         // Where the ping distances are stored.
uint8_t currentSensor = 0;          // Keeps track of which sensor is active.

NewPing sonar[SONAR_NUM] = {     // Sensor object array.
  //square
  NewPing(31, 6, MAX_DISTANCE), // Each sensor's trigger pin, echo pin, and max distance to ping.
  NewPing(28, 3, MAX_DISTANCE),
  NewPing(29, 4, MAX_DISTANCE),
  NewPing(30, 5, MAX_DISTANCE),
  //diagonal
  NewPing(40, 8, MAX_DISTANCE), // Each sensor's trigger pin, echo pin, and max distance to ping.
  NewPing(41, 9, MAX_DISTANCE),
  NewPing(42, 10, MAX_DISTANCE),
  NewPing(43, 11, MAX_DISTANCE),  

};

char incomeVal;

float sensorValue = 0;

//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup()
{
  
  //============================ PING
  Serial.begin(115200);
  pingTimer[0] = millis() + 75;           // First ping starts at 75ms, gives time for the Arduino to chill before starting.
  for (uint8_t i = 1; i < SONAR_NUM; i++){ // Set the starting time for each sensor.
    pingTimer[i] = pingTimer[i - 1] + PING_INTERVAL;  
  }
  

}

//=================================================================//
//=============================== LOOP ============================//
//=================================================================//

void loop()
{

  
  pinging();
//  while(Serial.available() >0){
//    Serial.write(Serial.read());
//  }  

  

}


//=================================================================//
//=============================== PING=============================//
//=================================================================//

void echoCheck() { // If ping received, set the sensor distance to array.
  if (sonar[currentSensor].check_timer())
    cm[currentSensor] = sonar[currentSensor].ping_result / US_ROUNDTRIP_CM;
}

void oneSensorCycle() { // Sensor ping cycle complete, do something with the results.
  for (uint8_t i = 0; i < SONAR_NUM; i++) {
    Serial.print(cm[i]);
    Serial.print(" ");
  }
  Serial.println();
}

void pinging() {
  for (uint8_t i = 0; i < SONAR_NUM; i++) { // Loop through all the sensors.
    if (millis() >= pingTimer[i]) {         // Is it this sensor's time to ping?
      pingTimer[i] += PING_INTERVAL * SONAR_NUM;  // Set next time this sensor will be pinged.
      if (i == 0 && currentSensor == SONAR_NUM - 1) oneSensorCycle(); // Sensor ping cycle complete, do something with the results.
      sonar[currentSensor].timer_stop();          // Make sure previous timer is canceled before starting a new ping (insurance).
      currentSensor = i;                          // Sensor being accessed.
      cm[currentSensor] = 0;                      // Make distance zero in case there's no ping echo for this sensor.
      sonar[currentSensor].ping_timer(echoCheck); // Do the ping (processing continues, interrupt will call echoCheck to look for echo).
    }
  }
}

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  





