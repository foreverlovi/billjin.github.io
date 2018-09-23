PVector drag;
void setup(){
  noCursor();
  frameRate(60);
  size(1280, 1280*2);
  
  drag = new PVector(0, 0);
}
void draw(){
  background(0, 0, 0);
  noStroke();
  fill(255, 255, 255);
  drag.x += (mouseX - drag.x)/4;
  drag.y += (mouseY - drag.y)/4;
  ellipse(drag.x, drag.y, 20-dist(mouseX, mouseY, drag.x, drag.y)/3, 20-dist(mouseX, mouseY, drag.x, drag.y)/3);
}
