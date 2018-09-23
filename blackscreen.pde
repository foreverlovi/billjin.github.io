PVector drag;
PFont hneue;
void setup(){
  noCursor();
  frameRate(60);
  size(1280, 1280*2);
  
  drag = new PVector(0, 0);
  hneue = createFont("Helvetica Neue Thin", 64);
}
void draw(){
  fill(0, 0, 0, 100);
  rect(0, 0, width, height);
  noStroke();
  fill(255, 255, 255);
  drag.x += (mouseX - drag.x)/7;
  drag.y += (mouseY - drag.y)/7;
  ellipse(drag.x, drag.y, 20-dist(mouseX, mouseY, drag.x, drag.y)/6, 20-dist(mouseX, mouseY, drag.x, drag.y)/6);
  
  textFont(hneue);
  text("Bill's Portfolio", 30, 70);
}
