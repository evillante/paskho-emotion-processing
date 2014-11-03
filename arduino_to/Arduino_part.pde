//=================================================================//
//============================= INITIT ============================//
//=================================================================// 

//=======================================================//
//========================= PING ========================//
//=======================================================// 
#include <NewPing.h>

#define SONAR_NUM     4 // Number or sensors.
#define MAX_DISTANCE 400 // Maximum distance (in cm) to ping.
#define PING_INTERVAL 50 // Milliseconds between sensor pings (29ms is about the min to avoid cross-sensor echo).

unsigned long pingTimer[SONAR_NUM]; // Holds the times when the next ping should happen for each sensor.
unsigned int cm[SONAR_NUM];         // Where the ping distances are stored.
uint8_t currentSensor = 0;          // Keeps track of which sensor is active.

NewPing sonar[SONAR_NUM] = {     // Sensor object array.
  NewPing(40, 2, MAX_DISTANCE), // Each sensor's trigger pin, echo pin, and max distance to ping.
  NewPing(38, 3, MAX_DISTANCE),
  NewPing(36, 4, MAX_DISTANCE),
  NewPing(34, 5, MAX_DISTANCE),
};

char incomeVal;

float sensorValue = 0;

//=======================================================//
//======================== SERVO ========================//
//=======================================================// 

// servo library
#include <Servo.h>  

  //SPIDER
Servo servo1;  
Servo servo2;
Servo servo3;  
Servo servo4;
  //CANVAS
Servo servo5;  
Servo servo6;
Servo servo7;  
Servo servo8;


int mid = 1500;
int spiderUp = mid + -50;

//spider dimens
float lengthX = 600;
float lengthY = 300;
  //ring 
  float rw = 110;
  float hrw = rw/2;

//movement of x & y axis
float moveX = 200;
float moveY = 50;

//ring variables
int frameUp = mid + 100;
int mag = 150;
int circSeg = 1000;

//find the midpoint of the frame
int s1i = spiderUp + 0;
int s2i = spiderUp + 0;
int s3i = spiderUp + 0;
int s4i = spiderUp + 0;

int s5i = frameUp + 200;
int s6i = frameUp + 0;
int s7i = frameUp + 250;
int s8i = frameUp + 250;

//HYPOTENOOSE

int h1 =  int( sqrt ( sq(moveX-hrw) + sq(moveY-hrw)) );
int h2 =  int( sqrt ( sq(lengthX-moveX-hrw) + sq(moveY-hrw)) );
int h3 =  int( sqrt ( sq(lengthX-moveX-hrw) + sq(lengthY-moveY-hrw)) );
int h4 =  int( sqrt ( sq(moveX-hrw) + sq(lengthY-moveY-hrw)) );

int midPoint = 262;

int c1 = midPoint - h1;
int c2 = midPoint - h2;
int c3 = midPoint - h3;
int c4 = midPoint - h4;

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
  
  //============================ SERVO
  //initialize servos (pin, min range, max range).
  servo1.attach(50, 1000, 2000);
  servo2.attach(49, 1000, 2000);
  servo3.attach(48, 1000, 2000);
  servo4.attach(47, 1000, 2000);  
  
  servo5.attach(30, 1000, 2000);
  servo6.attach(29, 1000, 2000);
  servo7.attach(28, 1000, 2000);
  servo8.attach(27, 1000, 2000);    

  
  //set initial position
  servo1.writeMicroseconds(s1i + c1);
  servo2.writeMicroseconds(s2i + c2);  
  servo3.writeMicroseconds(s3i + c3);
  servo4.writeMicroseconds(s4i + c4);   

  servo5.writeMicroseconds(s5i);
  servo6.writeMicroseconds(s6i);  
  servo7.writeMicroseconds(s7i);
  servo8.writeMicroseconds(s8i);    

  
/*
  Serial.println(c4);
  Serial.println(c3);
  Serial.println(c2);
  Serial.println(c1);
*/

}

//=================================================================//
//=============================== LOOP ============================//
//=================================================================//

void loop()
{

  
  pinging();
  while(Serial.available() >0){
    Serial.write(Serial.read());
  }  
  
  if (Serial.available()){
    incomeVal = Serial.read();
    if(incomeVal == '1'){ring(); delay(1000);}
  }
  
  /*
  sensorValue = analogRead(1); 
  Serial.println(sensorValue);
  delay(50);
  */
  
  //============================ SERVO
  //ring();
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

//=================================================================//
//=============================== RING ============================//
//=================================================================//
 void ring (){
 
    //1 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i);
    delay(circSeg); pinging();
    //1-2 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i - mag);
    delay(circSeg);  pinging();
    //2 up
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i - mag);
    delay(circSeg);  pinging();
    //2-3 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i - mag);
    delay(circSeg);  pinging();  
    //3 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i);
    delay(circSeg);  pinging();
    //3-4 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i + mag);
    delay(circSeg);  pinging();  
    //4 up
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i + mag);
    delay(circSeg);  pinging();  
    //4-1 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i + mag);
    delay(circSeg);   pinging();
    //ALL MID
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i);
    delay(circSeg);   pinging();   
 }
  
  
 
 void checkPull () {
   if (h1 > 262) {h1 = -h1;}
   if (h2 > 262) {h2 = -h2;}
   if (h3 > 262) {h3 = -h3;}
   if (h4 > 262) {h4 = -h4;}
 }
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  





