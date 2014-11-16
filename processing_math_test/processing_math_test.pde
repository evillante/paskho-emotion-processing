float w = 1100; float h = 880;
int appW = int(w); int appH = int(h);

float hn = 68.75;
float n = hn*2;
float x = w/2; float y = h/2;

void setup() {
  
if(x < hn){x = hn;}  if(x > w-hn) {x = w-hn;}
if(y < hn){y = hn;}  if(y > h-hn) {y = h-hn;}

size (appW,appH);

int c1 = int( sqrt ( sq(x-hn) + sq(y-hn)  ) );
int c2 = int( sqrt ( sq(w-x-hn) + sq(y-hn)  ) );
int c3 = int( sqrt ( sq(w-x-hn) + sq(h-y-hn)  ) );
int c4 = int( sqrt ( sq(x-hn) + sq(h-y-hn)  ) );  

int midPoint = 0;

int p1 = midPoint - c1;
int p2 = midPoint - c2;
int p3 = midPoint - c3;
int p4 = midPoint - c4;

println(p4);
println(p3);
println(p2);
println(p1);
  
  
  rectMode(CENTER);
  rect(x, y, n, n);
  //HYPOTENOOOOOOOSE
  stroke(200,50,50);
  line(0,h,x-hn,y+hn); //C1  //red
  
  stroke(50,200,50);
  line(w,h,x+hn,y+hn); //C2        //green
  
  stroke(50,50,200);
  line(w,0,x+hn,y-hn); //C3        //blue
  
  stroke(50,50,50);
  line(0,0,x-hn,y-hn); //C4        //black
  

  float xt = 550;
  float test = 0;

  if(xt > 900){
    test = map(test, 900, 1100, 0, 60);
  }


}





