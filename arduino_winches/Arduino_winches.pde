
//=======================================================//
//======================== SERVO ========================//
//=======================================================// 

float troub1 = 0;
float troub2 = 0;
float troub3 = 0;
float troub4 = 0;

float troubXB = 0;
float troubXS = 0;

float troubYB = 0;
float troubYS = 0;

float troubTX = 0;

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

int mid;
int spiderUp;
int frameUp;
int mag;
int circSeg;

int s1i;
int s2i;
int s3i;
int s4i;
int s5i;
int s6i;
int s7i;
int s8i;

//spider dimens
float lengthX;
float lengthY;
int midPoint;

//ring 
float rw;
float hrw;

//movement of x & y axis
float moveX;
float moveY; 









//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup()
{
  Serial.begin(300);

  
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
  

    
  mid = 1500;
  spiderUp = mid + -80;
  //ring variables
  frameUp = mid + -100;
  mag = 150;
  circSeg = 1000;
  
  //spider dimens
  lengthX = 1100;
  lengthY = 800;
  
  int midPoint = 630; //when all lines are equal distance
  
  //ring 
  rw = 160;
  hrw = rw/2;  
  


  
  //movement of x & y axis
  moveX = 450;
  moveY = 400;  



//================================================
//================= TROUBLESHOOT =================
//================================================

/* This is tweaking/callibrating the position of the spider based off the initial co-geo position*/
  
  if(moveX>=800){
    troub1 = map(moveX, 800, 1100, 0, 150);    
    troub2 = map(moveX, 800, 1100, 0, 50);
    troub3 = map(moveX, 800, 1100, 0, 30);
    troub4 = map(moveX, 800, 1100, 0, 150);
  }

  if(moveX<=500){
    troubXS = map(moveX, 0, 500, 0, 120);
    troubXS = 120-troubXS;
    troub2 = troub2 + (50 - map(moveX, 0, 500, 0, 50));
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS;
  }
  
  //callibration for the Y position
  if(moveY>400){
    troubYB = map(moveY, 400, 800, 0, 100);
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS;
  }
  
  if(moveY<400){
    troubYS = map(moveY, 0, 400, 0, 80);
    troubYS = 80 - troubYS;
    spiderUp = spiderUp + troubXB + troubXS + troubYB + troubYS;
  }
  
  
  
  
  if(moveX > 800 && moveY > 400){
    Serial.println(troubXB);
    Serial.println(troubXS);
    Serial.println(troubYB);
    Serial.println(troubYS);  
  }
  


//================================================
//================================================




  //find the midpoint of the frame
  s1i = spiderUp + 30 + troub1;
  s2i = spiderUp + 30 + troub2;
  s3i = spiderUp + 0 + troub3;
  s4i = spiderUp + 0 + troub4;
  
  s5i = frameUp + 100;
  s6i = frameUp + 70;
  s7i = frameUp + 20;
  s8i = frameUp + 130;

  //HYPOTENOOSE
  int h1 =  int( sqrt ( sq(moveX-hrw) + sq(moveY-hrw)) );
  int h2 =  int( sqrt ( sq(lengthX-moveX-hrw) + sq(moveY-hrw)) );
  int h3 =  int( sqrt ( sq(lengthX-moveX-hrw) + sq(lengthY-moveY-hrw)) );
  int h4 =  int( sqrt ( sq(moveX-hrw) + sq(lengthY-moveY-hrw)) );
  
  
  int c1 = midPoint - h1;
  int c2 = midPoint - h2;
  int c3 = midPoint - h3;
  int c4 = midPoint - h4;
  
  //set initial position
  servo1.writeMicroseconds(s1i + c1);
  servo2.writeMicroseconds(s2i + c2);  
  servo3.writeMicroseconds(s3i + c3);
  servo4.writeMicroseconds(s4i + c4);   

  servo5.writeMicroseconds(s5i);
  servo6.writeMicroseconds(s6i);  
  servo7.writeMicroseconds(s7i);
  servo8.writeMicroseconds(s8i);    


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
    delay(1000);
    //1-2 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i - mag);
    delay(1000);
    //2 up
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i - mag);
    delay(1000);
    //2-3 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i + mag);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i - mag);
    delay(1000);
    //3 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i);
    delay(1000);
    //3-4 up
    servo5.writeMicroseconds(s5i - mag);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i + mag);
    servo8.writeMicroseconds(s8i + mag);
   delay(1000); 
    //4 up
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i + mag);
    delay(1000);
    //4-1 up
    servo5.writeMicroseconds(s5i + mag);
    servo6.writeMicroseconds(s6i - mag);  
    servo7.writeMicroseconds(s7i - mag);
    servo8.writeMicroseconds(s8i + mag);
    delay(1000);
    //ALL MID
    servo5.writeMicroseconds(s5i);
    servo6.writeMicroseconds(s6i);  
    servo7.writeMicroseconds(s7i);
    servo8.writeMicroseconds(s8i);   
    delay(1000);
 }
  
void reset() {
troub1 = 0;
troub2 = 0;
troub3 = 0;
troub4 = 0;

troubXB = 0;
troubXS = 0;
troubYB = 0;
troubYS = 0;
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  





