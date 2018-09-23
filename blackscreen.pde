void setup(){
  frameRate(30);
  size(500, 500);
}
void draw(){
  background(0, 0, 0);
  noStroke();
  fill(255, 255, 255);
  ellipse(mouseX, mouseY, 50-dist(mouseX, mouseY, pmouseX, pmouseY)*2, 50-dist(mouseX, mouseY, pmouseX, pmouseY)*2);
}
