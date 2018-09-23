PVector drag;
PFont hneue;
void setup(){
  noCursor();
  frameRate(120);
  size(1280, 1280*2);
  
  drag = new PVector(0, 0);
  hneue = createFont("Helvetica Neue Thin", 64);
}
void draw(){
  fill(0, 0, 0, 130);
  rect(0, 0, width, height);
  noStroke();
  fill(255, 255, 255);
  drag.x += (mouseX - drag.x)/4;
  drag.y += (mouseY - drag.y)/4;
  ellipse(drag.x, drag.y, 20-dist(mouseX, mouseY, drag.x, drag.y)/3, 20-dist(mouseX, mouseY, drag.x, drag.y)/3);
  
  textFont(hneue);
  text("Bill's Portfolio", 30, 70);
}
