//serial port stuff
import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port



//serial port stuff END
//-------------------------------------------------------------------------------- global variables ---// 
int appSize = 800;
int halfApp = appSize/2;

//rect center
float rectCenterX = 400;
float rectCenterY = 400;
float rectSize = 250;
float rectHalf = rectSize/2;

//zones
float outerZone = appSize;
float goodZone = 150;
float dangerZone = 25;

int inZone;    //0 for emotion  1 for danger    2 for good    3 for outer

//emotion point
float ePointX = rectCenterX;
float ePointY = rectCenterY;
float boxWidth =20;

//in the boxes
boolean inBox = false;
boolean inClear = false;
boolean peopleAt = false;

//array of people coordinates
int arrayLength = 4;
int [] ax = new int[arrayLength];
int [] ay = new int[arrayLength];
boolean [] drag = new boolean[arrayLength];
int [] aZone = new int[arrayLength];
int [] personZone = new int[arrayLength];

int slot = 0;
int numberOfPeople = 0;


int[] distances = new int[arrayLength];
int[] movement = new int[arrayLength];

//position of emotion dot
float moveX = 0;
float moveY = 0;
float posX = rectCenterX;
float posY = rectCenterY;

//buffer emotion
float bufferLimit = 200;
float bufferOrigin = rectHalf;

float bufferH = bufferOrigin;
float bufferS = bufferOrigin;
float bufferE = bufferOrigin;
float bufferC = bufferOrigin;


//person position *Random movement*
float pMoveX = 0;
float pMoveY = 0;

//time
int t1;
int t2;

//in zones
int inZone1 = 0;
int inZone2 = 0;
int inZone3 = 0;

//directions
float north;
float south;
float east;
float west;
//=================================================================//
//============================== SETUP ============================//
//=================================================================// 

void setup() {
  //================================================================= SERIAL PORT STUFF
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, "/dev/tty.usbmodem1a1311", 115200);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;  
  //TO SEND
  //================================================================= SERIAL PORT STUFF END
  size(appSize, appSize);
  background(255, 255, 255);

  //-- set initial position --//
  for (int i = 0; i < arrayLength; i++) {
    ax [i] = 0;
    ay [i] = 0;
    drag [i] = false;
    aZone[i] = 0;
  }
}

//=================================================================//
//============================== DRAW =============================//
//=================================================================//

void draw() {
 

  rectMode(CENTER);
  noStroke();

  //--------------------------------------------------------------- zones
  //------------------------------------------------- Outer
  fill(150, 150, 255);
  rect(rectCenterX, rectCenterY, outerZone, outerZone);

  //------------------------------------------------- Good
  fill(150, 255, 150);
  rect(rectCenterX, rectCenterY, rectSize+goodZone*2, rectSize+goodZone*2);

  //------------------------------------------------- DANGER
  fill(255, 0, 0);
  rect(rectCenterX, rectCenterY, rectSize+dangerZone*2, rectSize+dangerZone*2);

  //--------------------------------------------------------------- emotion box
  rectMode(CENTER);
  fill(255);
  stroke(0);
  rect(rectCenterX, rectCenterY, rectSize, rectSize);

  //--------------------------------------------------------------- text around the rectangle
  fill(0);
  text ( "Happy", rectCenterX-20, rectCenterY-180); 
  text ( "Sad", rectCenterX-5, rectCenterY+180); 
  text ( "Excited", rectCenterX-210, rectCenterY-10); 
  text ( "Calm", rectCenterX+180, rectCenterY-10);   


  //--------------------------------------------------------------- emotion grid
  for (int i = 0; i < 10; i++) {
    rectMode(CENTER);
    stroke(0);
    noFill();
    rect(rectCenterX, rectCenterY, (rectSize/10)*i, (rectSize/10)*i);
  }

  //--------------------------------------------------------------- people
  noStroke();
  fill(0);
  movePerson();

  //--------------------------------------------------------------- time
  int time = millis();
  int s = time/1000;

  text (s, 180, 30);
  
  int timeTest = 5;
  
  if (s >= timeTest && s < (timeTest + 120) ){
    int nt = (s - timeTest)/2;
    float rnt = round(nt);
    float rntd = rnt/10;
    
    text (rntd, 180, 50);
  }

  //--------------------------------------------------------------- emotion dot
  //draw dot
  fill(50, 100, 50);
  noStroke();
  ellipse(posX, posY, 10, 10);
  //buffer position visual
  stroke(0,150,150);
  strokeWeight(2);
  line(rectCenterX - bufferE, rectCenterY - bufferH, rectCenterX + bufferC, rectCenterY -bufferH);    //happy line
  line(rectCenterX + bufferC, rectCenterY - bufferH, rectCenterX + bufferC, rectCenterY + bufferS);   //calm line
  line(rectCenterX - bufferE, rectCenterY + bufferS, rectCenterX + bufferC, rectCenterY + bufferS);   //sad line
  line(rectCenterX - bufferE, rectCenterY - bufferH, rectCenterX - bufferE, rectCenterY + bufferS);   //excited line
  strokeWeight(1);
  emotionDot();

}

//=================================================================//
//===================== SERIAL PORT FUNCTION ======================//
//=================================================================//

void serialEvent(Serial myPort) {
  myString = myPort.readStringUntil(lf);
  if (myString != null) {
    myString = trim(myString);
    
    int[] distances = int(split(myString, " "));

    
    for (int i = 0 ; i < arrayLength ; i++){
      movement[i] = distances[i];

    }    
          //println(movement);
  }

  
}

//=================================================================//
//======================== Basic Functions ========================//
//=================================================================//

//-------------------------------------------------------------------------------- Emotion ---//

void emotionDot () {
  //reset number of people in zones
  inZone1 = 0;  inZone2 = 0;  inZone3 = 0;
  
  for(int i = 0 ; i < arrayLength ; i++){
    checkZone(i);
    
    //count number of people in Zones
    if(aZone[i] == 1) {inZone1++;}
    if(aZone[i] == 2) {inZone2++;}
    if(aZone[i] == 3) {inZone3++;}
    
    //-----------------------------------------------------movement logic
    //if more people in good than outer
    if(inZone2 > inZone3) {
      moveX +=0.2; moveY-=0.2;
    }
    //more people in outer than good
    if(inZone3 > inZone2) {
      moveX +=0.2; moveY +=0.2;
    }
    
    if( (inZone3 == inZone2) && (inZone3 == 0) && (inZone2 == 0) ) {
      if (moveX < 0 ){moveX+= 0.2;}
      if (moveX > 0 ){moveX-= 0.2;}
      if (moveY < 0 ){moveY+= 0.2;}
      if (moveY > 0 ){moveY-= 0.2;}
      moveX += 0; moveY += 0;
    }
    
    if(aZone[i] == 1){
      moveX -=1; moveY +=1;
    }
    
  }
  
  //print(inZone1 + " " + inZone2 + " " + inZone3);
  //println();

  //limit emotion point to buffer
  if(rectCenterX + moveX >= rectCenterX + bufferC) {moveX = bufferC;}
  if(rectCenterX + moveX <= rectCenterX - bufferE) {moveX = -bufferE;}
  if(rectCenterY + moveY >= rectCenterY + bufferS) {moveY = bufferS;}
  if(rectCenterY + moveY <= rectCenterY - bufferH) {moveY = -bufferH;}  
  
  //MOVE THE DOT
  posX = rectCenterX + moveX;
  posY = rectCenterY + moveY;
  
  //-------MOVE THE BUFFER
  // to outer limit
  if(posX >= (rectCenterX + bufferC - 5) && bufferC <= bufferLimit){bufferC += 0.5;}else{bufferC -= 0.5;}
  if(posX <= (rectCenterX - bufferE + 5) && bufferE <= bufferLimit){bufferE += 0.5;}else{bufferE -= 0.5;}
  if(posY >= (rectCenterY + bufferS - 5) && bufferS <= bufferLimit){bufferS += 0.5;}else{bufferS -= 0.5;}
  if(posY <= (rectCenterY - bufferH + 5) && bufferH <= bufferLimit){bufferH += 0.5;}else{bufferH -= 0.5;}
  // to min
  if(bufferC <= bufferOrigin){bufferC = bufferOrigin;}
  if(bufferE <= bufferOrigin){bufferE = bufferOrigin;}
  if(bufferS <= bufferOrigin){bufferS = bufferOrigin;}
  if(bufferH <= bufferOrigin){bufferH = bufferOrigin;}
  //to minimum


  //restrict movement    
  if (posX > (rectCenterX+rectHalf) ) {
    posX = rectCenterX+rectHalf;
  }
  if (posX < (rectCenterX-rectHalf) ) {
    posX = rectCenterX-rectHalf;
  }
  if (posY > (rectCenterY+rectHalf) ) {
    posY = rectCenterX+rectHalf;
  }
  if (posY < (rectCenterY-rectHalf) ) {
    posY = rectCenterX-rectHalf;
  }
}

//-------------------------------------------------------------------------------- move people ---//

void movePerson() {

  rectMode(CENTER);
    //println(movement);
    //println(" ");
    north = map(movement[0], 0, 200, 0, halfApp);
    east = map(movement[1], 0, 200, 0, halfApp);
    south = map(movement[2], 0, 200, 0, halfApp);   
    west = map(movement[3], 0, 200, 0, halfApp);  
    
    if (north == 0){north = halfApp;}
    if (east == 0){east = halfApp;}
    if (south == 0){south = halfApp;}
    if (west == 0){west = halfApp;}
    
    //north values
    ay[0] = int(halfApp - north);
    ax[0] = halfApp;
    //east values
    ax[1] = int(halfApp + east);
    ay[1] = halfApp;
    //south values
    ay[2] = int(halfApp + south);
    ax[2] = halfApp;    
    //west values
    ax[3] = int(halfApp - west);
    ay[3] = halfApp;       
    
    //println(movement);


  for (int i = 0; i < arrayLength; i++) {
      checkZone(i);
      aZone[i] = personZone[i];
      if(aZone[i] == 1){
        fill(0);
        myPort.write('1');
        println('1');
        //println('danger');
      }
      if(aZone[i] == 2){fill(125);}
      if(aZone[i] == 3){fill(255);}
      
      println(aZone);
      
    rect(ax[i], ay[i], 20, 20);
  }
}



//-------------------------------------------------------------------------------- people counter ---//

void countPeople() {

  for (int i = 1; i <= arrayLength; i++) {
    if (ax[i-1] != 0) {
      numberOfPeople = i;
    }
  }
  //print("number of people " + numberOfPeople);
  //println(" ");
}



//-------------------------------------------------------------------------------- inBox ---//

//check if in emotion container
void inBox () {
  if (( (mouseX < rectCenterX-rectHalf-10) || (mouseX > rectCenterX+rectHalf+10) ) || ( (mouseY < rectCenterX-rectHalf-10) || (mouseY > rectCenterX+rectHalf+10) ) ) {
    inBox = false;
  } else {
    inBox= true;
  }
}

//check if in clear
void inClear() {
  if (( (mouseX < 10) || (mouseX > 110) ) || ( (mouseY < 13) || (mouseY > 37) ) ) {
    inClear = false;
  } else {
    inClear= true;
  }
}



//----------------------------------array points in zones

void checkZone(int i ) {
 
  if(
      (  ax[i] > 0 && ax[i] < appSize  )  //if within boundries of the app
      &&
      (  ay[i] > 0 && ay[i] < appSize  )
    ) {personZone[i] = 3;}
    
  if(
      (  ax[i] > (rectCenterX - rectHalf - goodZone)  )  &&  (  ax[i] < (rectCenterX + rectHalf + goodZone)  )  //if within boundries of good
      &&
      (  ay[i] > (rectCenterY - rectHalf - goodZone)  )  &&  (  ay[i] < (rectCenterY + rectHalf + goodZone)  )
     ) {personZone[i] = 2;} 
     
  if(
      (  ax[i] > (rectCenterX - rectHalf - dangerZone)  ) &&  (  ax[i] < (rectCenterX + rectHalf + dangerZone)  )  //if within the DANGER ZONE!
      &&
      (  ay[i] > (rectCenterY - rectHalf - dangerZone)  ) &&  (  ay[i] < (rectCenterY + rectHalf + dangerZone)  )
    ) {personZone[i] = 1;} 
    
  if(north == 400) {personZone[0] = 0;}
  if(east == 400) {personZone[1] = 0;}
  if(south == 400) {personZone[2] = 0;}
  if(west == 400) {personZone[3] = 0;}

}
//-----------------------------------------------------------------------------------//
































