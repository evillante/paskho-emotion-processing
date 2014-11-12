int w = 1100; int h = 1000;
int n = 160;
int hn = n/2;
int x = w/2; int y = h/2;

void setup() {
  
if(x < hn){x = hn;}  if(x > w-hn) {x = w-hn;}
if(y < hn){y = hn;}  if(y > h-hn) {y = h-hn;}

size (w,h);

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
  
  

}




//  800 |  624
//  700 |  596
//  600 |  572



