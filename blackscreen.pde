PVector drag;
void setup(){
  frameRate(60);
  size(500, 500);
  
  drag = new PVector(0, 0);
}
void draw(){
  background(0, 0, 0);
  noStroke();
  fill(255, 255, 255);
  drag.x += (mouseX - drag.x)/20;
  drag.y += (mousey - drag.y)/20;
  ellipse(drag.x, drag.y, 50-dist(mouseX, mouseY, drag.x, drag.y), 50-dist(mouseX, mouseY, drag.x, drag.y));
}
