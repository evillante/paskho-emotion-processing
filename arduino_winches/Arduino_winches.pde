
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
float lengthX = 900;
float lengthY = 600;
  //ring 
  float rw = 10;
  float hrw = rw/2;

//movement of x & y axis
float moveX = 0;
float moveY = 0;


//ring variables
int frameUp = mid + -100;
int mag = 150;
int circSeg = 1000;

//find the midpoint of the frame
int s1i = spiderUp + 0;
int s2i = spiderUp + 140;
int s3i = spiderUp + 100;
int s4i = spiderUp + 130;

int s5i = frameUp + 100;
int s6i = frameUp + 70;
int s7i = frameUp + 20;
int s8i = frameUp + 130;

//HYPOTENOOSE

int h1 =  int( sqrt ( sq(moveX-hrw) + sq(moveY-hrw)) );
int h2 =  int( sqrt ( sq(lengthX-moveX-hrw) + sq(moveY-hrw)) );
int h3 =  int( sqrt ( sq(lengthX-moveX-hrw) + sq(lengthY-moveY-hrw)) );
int h4 =  int( sqrt ( sq(moveX-hrw) + sq(lengthY-moveY-hrw)) );


int midPoint = 403; //when all lines are equal distance
int c1 = midPoint - h1;
int c2 = midPoint - h2;
int c3 = midPoint - h3;
int c4 = midPoint - h4;

//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup()
{
  Serial.begin(300);
  if(moveX < hrw){moveX = hrw;}  //if(moveY > lengthX-hrw){moveX=lengthX-hrw;}
  if(moveY < hrw){moveY = hrw;}  //if(moveY > lengthY-hrw){moveX=lengthY-hrw;}
  
  //============================ SERVO
  //initialize servos (pin, min range, max range).
  //spider
  servo1.attach(10, 1000, 2000);
  servo2.attach(5, 1000, 2000);
  servo3.attach(4, 1000, 2000);
  servo4.attach(11, 1000, 2000);  
  //frame
  servo5.attach(2, 1000, 2000);
  servo6.attach(3, 1000, 2000);
  servo7.attach(12, 1000, 2000);
  servo8.attach(13, 1000, 2000);    

  Serial.println(c1);
  Serial.println(c2);
  Serial.println(c3);
  Serial.println(c4);
  
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
  //ring();
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
    //1-2 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i - mag);
    //2 up
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i - mag);
    //2-3 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i - mag);
    //3 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i);
    //3-4 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i + mag); 
    //4 up
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i + mag);
    //4-1 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i + mag);
    //ALL MID
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i);   
 }
  
  
 
 void checkPull () {
   if (h1 > 262) {h1 = -h1;}
   if (h2 > 262) {h2 = -h2;}
   if (h3 > 262) {h3 = -h3;}
   if (h4 > 262) {h4 = -h4;}
 }
 
 long CmMs(long cm){
   return (cm*29*2);
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  





