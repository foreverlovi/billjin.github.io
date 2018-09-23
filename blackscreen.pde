PVector drag;
PFont hneue;
ArrayList<traildot> trail = new ArrayList<traildot>();
void setup(){
  noCursor();
  frameRate(60);
  size(window.innerWidth-20, (window.innerWidth-20)*2);
  
  drag = new PVector(0, 0);
  hneue = createFont("Helvetica Neue Light", 64);
}
void draw(){
  background(0);
  noStroke();
  fill(255, 255, 255);
  drag.x += (mouseX - drag.x)/7;
  drag.y += (mouseY - drag.y)/7;
  ellipse(drag.x, drag.y, 20-dist(mouseX, mouseY, drag.x, drag.y)/4.5, 20-dist(mouseX, mouseY, drag.x, drag.y)/4.5);
  trail.add(new traildot());
  drawtrail();
  
  fill(255, 255, 255);
  textFont(hneue);
  text("Bill's Portfolio", 30, 70);
}
class traildot {
  float x, y, trans, rx, ry, sz;
  traildot(){
    x = drag.x;
    y = drag.y;
    trans = 155;
    rx = random(-1, 1);
    ry = random(-1, 1);
    sz = random(5, 20)-dist(mouseX, mouseY, drag.x, drag.y)/4.5;
  }
  void update(){
    x += rx;
    y += ry;
    trans -= 10;
    noStroke();
    fill(255, trans);
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
