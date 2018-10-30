/* @pjs font=/data/SurroundingBold.otf */
boolean purple, on, downn;
int swipe, down, counter;
int reset;
float xx, start, time, cosa;
PFont surroundingfont;
game newgame;

float[] ballpositions;
String[] losingchances;
int[] times;
boolean[] fall;
void setup(){
  size(960, 540);
  surroundingfont = createFont("/data/SurroundingBold.otf");
  purple = false;
  swipe = 720;
  downn = false;
  down = -20;
  counter = 1;
  on = false;
  xx = 0;
  start = 0;
  time = 49;
  cosa = 0;
  reset = 0;
  
  frameRate(50);
  
  ballpositions = new float[12];
  losingchances = new String[7];
  times = new int[7];
  fall = new boolean[7];
  newgame = new game();
};
void generateterrain(float y, float offs){
  noFill();
  float xoff = start;
  beginShape();
  for(int i = 0; i < width; i++){
    stroke(0);
    if(int(time/4.5) % 3 == 0){
      stroke(0,255,255);
    }
    strokeWeight(5+(y/100));
    /*if(int(time)/36 % 2 == 0){
      stroke(0,255,255);
      strokeWeight(40+(y/50));
    } else {
      fill(0,255,255);
    }*/
    fill(0,255,255);
    if(int(time/49) % 3 == 0){
      stroke(100);
      strokeWeight(8+(y/100));
    }
    float a = noise(xoff)*height/3;
    vertex(i,a+y);
    xoff+= offs;
    cosa += 2;
  }
  endShape();
  if(!on){
    start += 0.006;
    if(int(time/49) % 3 == 0){
      start += 0.01;
    }
  }
};
class ball {
  color c,front,upper,touch,ballcol,mid;
  float speed;
  float hreduct = 0.65;
  float y;
  float velocity = -1;
  float grvty = 0.13;
  float x = 250;
  int ident;
  float intime = 0.0;
  int losingchance = 0;
  ball(float hei,color col, int id) {
    ballcol = col;
    ident = id;
    y = hei;
  };
  void update(){
    //speed = random(0.5,1.7);
    speed = random(1,3);
    c = get(int(x+xx),int(y)+7);
    front = get(int(x+xx)+7,int(y)+5);
    upper = get(int(x+xx)+8,int(y)+3);
    touch = get(int(x+xx)+8,int(y)-1);
    mid = get(int(x+xx),int(y));
    y -= velocity;
    velocity -= grvty;
    if(touch == color(0)){
      velocity = -velocity;
      speed = 0.8;
      y-=2;
    }
    if(touch == color(100)){
      velocity = 4;
      speed = 1;
      y -= 4;
    }
    if(c == color(0) || c == color(100)){
      velocity *= hreduct;
      //velocity = -velocity;
      y-=2;
    }
    if(c == color(0,255,255)){
      speed -= 1.5;
      //if(int(millis()/random(333,555)) % 2 == 0){
        //velocity = random(0.5,1);
      //}
      velocity += 0.35;
    }
    /*for(int i = 1; i <= 6; i ++){
      if(dist(int(x+xx),int(y),ballpositions[i*2-2],ballpositions[i*2-1])<4){
        if (time > 75){
          velocity = -velocity;
        }
      }
    }*/
    if(front == color(0)|| front == color(100)){
      velocity = abs(speed)*1.3;
    }
    if(front == color(255,0,100)){
      velocity = 10;
    }
    if(upper == color(0)|| upper == color(100)){
      velocity = abs(speed)*2;
      y-=1;
    }
    x += speed;
    ballpositions[ident*2-2] = int(x+xx);
    ballpositions[ident*2-1] = int(y);
    if(y>300){
      losingchance = int((y-200)/height*100);
    }
    losingchances[ident] = "dropout chance: "+str(losingchance)+"%";
    if(y<301){
      losingchances[ident] = "is doing well!";
    }
    if(losingchance > 98){
      losingchances[ident] = "stayed on for\n"+intime/10+" seconds!";
    }
    if(y<height-20){
      intime = round(frameCount/6);
    }
    if(y>height+160){
      fall[ident]=true;
    }
  };
  void display(){
    textAlign(CENTER);
    textSize(20);
    noStroke();
    fill(ballcol);
    ellipse(x+xx, y,8+(y/40),8+(y/40));
    if(y>300){
      text(str(int((y-200)/height*100))+ "%",x+xx,y-20);
    }
  };
  void lin(){
    if(0 < y && y < height){
      stroke(ballcol,50);
      strokeWeight(2);
      line(x+xx, 0, x+xx, height);
    }
  };
};
class game{
  ball a = new ball(0,color(255,0,0),1);
  ball b = new ball(0,color(0,185,0),2);
  ball c = new ball(0,color(0,0,255),3);
  ball d = new ball(0,color(255,255,0),4);
  ball e = new ball(0,color(255,155,0),5);
  ball f = new ball(0,color(255,0,255),6);
  void update(){
    a.update(); b.update(); c.update(); d.update(); e.update(); f.update();
  };
  void display(){
    a.lin(); b.lin(); c.lin(); d.lin(); e.lin(); f.lin();
    a.display(); b.display(); c.display(); d.display(); e.display(); f.display();
  }
}
void draw(){
  background(255);
  fill(255,0,100);
  noStroke();
  rect(0, swipe, width, 10);
  generateterrain(0,0.007);
  generateterrain(height/3,0.005);
  generateterrain(height/3*2,0.003);
  if(!on){
    time += 0.14;
    xx -= 1.8;
    newgame.update();
  }
  iffs();
  newgame.display();
  counter++;
  fill(0);
  rect(width-200,0,200,height);
  
  textFont(surroundingfont);
  textAlign(CENTER,CENTER);
  textSize(20);
  fill(255,0,0);
  text("RED\n"+losingchances[1],width-100,height/12);
  fill(255,155,0);
  text("ORANGE\n"+losingchances[5],width-100,height/4);
  fill(255,255,0);
  text("YELLOW\n"+losingchances[4],width-100,height/12*5);
  fill(0,185,0);
  text("GREEN\n"+losingchances[2],width-100,height/12*7);
  fill(0,0,255);
  text("BLUE\n"+losingchances[3],width-100,height/12*9);
  fill(255,0,255);
  text("PINK\n"+losingchances[6],width-100,height/12*11);
  
  if(fall[1]&&fall[2]&&fall[3]&&fall[4]&&fall[5]&&fall[6]){
    reset++;
  }
  
  if(reset > 150){
    setup();
  }
};
void iffs(){
  if(purple){
    swipe -= 10;
  }
  if(swipe < 0){
    swipe = height;
    purple = false;
  }
  if(downn){
    down += 10;
  }
  if(down > height){
    down = -10;
    downn = false;
  }
  if(counter%500 == 0){
    purple = true;
  }
  if(counter%600 == 0){
    downn = true;
  }
};
