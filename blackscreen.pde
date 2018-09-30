/* @pjs font=/data/hneueLi64.ttf */ 

int mousecol, backcol;
PVector drag;
PImage bgradi, wgradi;
PFont hneue;
float portfolio;
ArrayList<traildot> trail = new ArrayList<traildot>();
ArrayList<buttons> btns = new ArrayList<buttons>();
ArrayList<clicks> click = new ArrayList<clicks>();
void setup(){
  noCursor();
  frameRate(60);
  smooth();
  size(window.innerWidth-30, (window.innerWidth-30)*2);
  
  drag = new PVector(0, 0);
  hneue = createFont("/data/hneueLi64.ttf");
  
  mousecol = 255;
  backcol = 0;
  
  bgradi = loadImage("/data/gradient.png");
  wgradi = loadImage("/data/wgradient.png");
  portfolio = -100;
  
  btns.add(new buttons((window.innerWidth-30)/7, 200, "https://imgur.com/4Tl9iYF.png", "https://www.youtube.com/watch?v=OfsOhYVnTdM", 255, "CO Episode 3 Part 1"));
  btns.add(new buttons((window.innerWidth-30)/2, 200, "https://imgur.com/USD4r3D.png", "https://www.youtube.com/watch?v=9x0IXjz23DI", 0, "CO Episode 2"));
  btns.add(new buttons((window.innerWidth-30)/7*6, 200, "https://imgur.com/AXG7FiA.png", "https://www.youtube.com/watch?v=gUVqwHdHgVc", 0, "CO Episode 1"));
}
void draw(){
  background(backcol);
  noStroke();
  
  fill(mousecol);
  textFont(hneue, 64);
  text("Bill's Portfolio", 30, portfolio);
  portfolio += (70-portfolio)/50;
  
  updatebuttons();
  drawclicks();
  
  fill(mousecol);
  drag.x += (mouseX - drag.x)/7;
  drag.y += (mouseY - drag.y)/7;
  ellipse(drag.x, drag.y, 20-dist(mouseX, mouseY, drag.x, drag.y)/3.5, 20-dist(mouseX, mouseY, drag.x, drag.y)/3.5);
  trail.add(new traildot());
  drawtrail();
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
void updatebuttons(){
  for(int i = 0; i < btns.size();  i ++){
    buttons btn = btns.get(i);
    btn.update();
  }
}
void keyReleased(){
  if(key=='c'){
    if(backcol==0){
      document.body.style.background = "#FFFFFF";    
    }
    if(backcol == 255){
      document.body.style.background = "#000000";
    }
    backcol = (backcol + 255)%510;
    mousecol = (mousecol + 255)%510;
  }
}
void drawclicks(){
  for(int i = 0; i < click.size(); i ++){
    clicks c = click.get(i);
    c.display();
  }
  for(int i = click.size()-1; i >= 0; i --){
    clicks c = click.get(i);
    if(frameCount-c.count>255){
      click.remove(i);
    }
  }
}
class clicks{
  PVector pos;
  float count;
  float countplus;
  clicks(){
    pos = new PVector(drag.x, drag.y);
    count = frameCount;
  }
  void display(){
    fill(mousecol, (255/8-(frameCount-count))*6);
    ellipse(pos.x, pos.y, (frameCount-count)*4, (frameCount-count)*4);
  }
}
class buttons{
  PVector pos;
  int ypos;
  PImage img;
  String linkto;
  int tc;
  float sz;
  String cap;
  buttons(int x, int y, String thumbnail, String clicklink, int textc, String caption){
    pos = new PVector(0,0);
    pos.x = x;
    pos.y = y+30;
    ypos = y;
    img = loadImage(thumbnail);
    linkto = clicklink;
    tc = textc;
    cap = caption;
    sz = 0;
  }
  void update(){
    rectMode(CENTER);
    fill(mousecol);
    rect(pos.x, pos.y, sz, width/4/(16/9)+2);
    if(frameCount>60){
      sz += ((width/4+2)-sz) / 15;
    }
    imageMode(CENTER);
    image(img, pos.x, pos.y, width/4, width/4/(16/9));
    if(tc == 255){
      image(bgradi, pos.x, pos.y, width/4, width/4/(16/9));
    } else if(tc==0){
      image(wgradi, pos.x, pos.y, width/4, width/4/(16/9));
    }
    if(mouseY>pos.y-width/8/(16/9) && mouseY < pos.y+width/8/(16/9)&&mouseX>pos.x-width/8 && mouseX < pos.x+width/8){
      pos.y += ((ypos-30)-pos.y)/15;
      fill((tc+255)%510, ((ypos)-pos.y)*(55/30)*0.75);
    } else {
      fill(backcol, ((ypos+30)-pos.y)*(255/30)*-1+255);
      pos.y += (ypos-pos.y)/15;
    }
    rect(pos.x, pos.y, width/4, width/4/(16/9));
    
    fill(tc);
    textFont(hneue, 20);
    text(cap, pos.x-width/8+10, pos.y+width/8/(16/9)-10);
  }
}
void mouseClicked(){
  click.add(new clicks());
  for(int i = 0; i < btns.size();  i ++){
    buttons btn = btns.get(i);
    if(mouseX>btn.pos.x-width/8 && mouseX < btn.pos.x+width/8){
      if(mouseY>btn.pos.y-width/8/(16/9) && mouseY < btn.pos.y+width/8/(16/9)){
        link(btn.linkto, "_new");
      }
    }
  }
}
