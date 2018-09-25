/* @pjs font=/data/hneueLi64.ttf */ 

int mousecol, backcol;
PVector drag;
PFont hneue;
float portfolio;
boolean switchc;
ArrayList<traildot> trail = new ArrayList<traildot>();
void setup(){
  noCursor();
  frameRate(60);
  size(window.innerWidth-30, (window.innerWidth-30)*2);
  
  drag = new PVector(0, 0);
  hneue = createFont("/data/hneueLi64.ttf");
  
  mousecol = 255;
  backcol = 0;
  
  portfolio = -100;
  switchc = false;
}
void draw(){
  background(backcol);
  noStroke();
  fill(mousecol);
  drag.x += (mouseX - drag.x)/7;
  drag.y += (mouseY - drag.y)/7;
  ellipse(drag.x, drag.y, 20-dist(mouseX, mouseY, drag.x, drag.y)/3.5, 20-dist(mouseX, mouseY, drag.x, drag.y)/3.5);
  trail.add(new traildot());
  drawtrail();
  
  fill(mousecol);
  textFont(hneue, 64);
  text("Bill's Portfolio", 30, portfolio);
  while(portfolio<=69.7){
    portfolio += (70-portfolio)/50;
  }
  if(switchc){
    if(backcol<5){
      backcol = 255;
      mousecol = 0;
      switchc = false;
    }
    if(backcol>250){
      backcol = 0;
      mousecol = 255;
      switchc = false;
    }
  }
}
class traildot {
  float x, y, trans, rx, ry, sz;
  traildot(){
    x = drag.x;
    y = drag.y;
    trans = 155;
    rx = random(-1, 1);
    ry = random(-1, 1);
    sz = random(5, 20)-dist(mouseX, mouseY, drag.x, drag.y)/3.5;
  }
  void update(){
    x += rx;
    y += ry;
    trans -= 10;
    noStroke();
    fill(mousecol, trans);
    ellipse(x, y, sz, sz);
  }
}
void drawtrail(){
  for(int i = 0; i < trail.size(); i++){
    traildot t = trail.get(i);
    t.update();
  }
  for(int i = trail.size() - 1; i>=0; i--){
    traildot t = trail.get(i);
    if(t.trans<=0){
      trail.remove(i);
    }
  }
}
void keyReleased(){
  if(key=='c'){
    switchc = true;
  }
}
