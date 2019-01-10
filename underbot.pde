/* @pjs font=/data/MonsterFriendFore.otf */
/* @pjs font=/data/DTM-Mono.otf */
ArrayList<bullet> bullets = new ArrayList<bullet>();
boolean[] keys = new boolean[101];
PVector boxsize;
PVector player, botpos;
int bwid = 5;
int hp = 84, bhp = 126;
int heartcolour = 0, botcol = -155;

int bulcount = 0;
boolean countbul = false;
PVector nearbullet, nearvel, nearbotb, nearbotv;
String control;

PVector sizechange;

boolean guide = false;

String screen = "menu";

int tooclose;

int streamcnt = 0;
int bburstcnt = 0;
int lburstcnt = 0;

int currfc;

boolean cntstr = false;

PFont monsterfriend, dtmmono;

void setup(){
  size(800, 600);
  boxsize = new PVector(200, 200);
  player = new PVector(width / 3, 400);
  botpos = new PVector(width / 3 * 2, 400);
  
  nearbullet = new PVector(0, 0);
  nearvel = new PVector(0, 0);
  nearbotb = new PVector(0, 0);
  nearbotv = new PVector(0,  0);
  sizechange = new PVector(0, 1000);
  control = "bot";
  
  bullets.add(new bullet(width/3*2-112, 400-112, "bot", true));
  bullets.add(new bullet(width/3*2-112, 400+112, "bot", true));
  bullets.add(new bullet(width/3*2+112, 400-112, "bot", true));
  bullets.add(new bullet(width/3*2+112, 400+112, "bot", true));
  
  monsterfriend = createFont("/data/MonsterFriendFore.otf", 48);
  dtmmono = createFont("/data/DTM-Mono.otf", 48);
}

void draw(){
  switch(screen){
    case "game":
      background(0);
      noFill();
      stroke(255);
      strokeWeight(bwid);
      rectMode(CENTER);
      rect(width/3, 400, boxsize.x, boxsize.y);
      rect(width/3*2, 400, boxsize.x, boxsize.y);
      
      noStroke();
      fill(255, 0, 0);
      rect(width / 3, 550, 126, 30);
      
      rectMode(CORNER);
      fill(255, 255, 0);
      rect(width / 3 - 63, 535, hp * 1.5, 30);
      
      rectMode(CENTER);
      noStroke();
      fill(255, 0, 0);
      rect(width / 3 * 2, 550, 126, 30);
      
      rectMode(CORNER);
      fill(255, 255, 0);
      rect(width / 3 * 2 - 63, 535, bhp, 30);
      
      if(keys[UP]) player.y -= 2;
      if(keys[LEFT]) player.x -= 2;
      if(keys[DOWN]) player.y += 2;
      if(keys[RIGHT]) player.x += 2;
      
      player.x = constrain(player.x, width/3 - boxsize.x / 2 + bwid + 6, width/3 + boxsize.x / 2 - bwid - 5);
      player.y = constrain(player.y, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      
      botpos.x = constrain(botpos.x, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
      botpos.y = constrain(botpos.y, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      
      stroke(255, 155);
      strokeWeight(1);
      line(nearbotb.x, nearbotb.y, botpos.x, botpos.y);
      
      botcontrol();
      
      runbullets();
      heart();
      botheart();
      
      spawnbullets();
      buttons();
      closelines();
      
      if(countbul){
        bulcount++;
        if(bulcount>18){
          bulcount = 0;
          countbul = false;
        }
      }
      
      if(hp == 0 && bhp > 0) screen = "botwins";
      if(bhp == 0 && hp > 0) screen = "playerwins";
    break;
    case "botwins":
      textAlign(CENTER);
      textFont(dtmmono);
      background(0);
      botheart();
      fill(155);
      textSize(30);
      text("you lost.", width/2, 150);
    break;
    case "playerwins":
      textAlign(CENTER);
      textFont(dtmmono);
      background(0);
      heart();
      fill(255, 0, 0);
      textSize(30);
      text("you won.", width/2, 150);
    break;
    case "menu":
      background(0);
      textFont(monsterfriend);
      textSize(48);
      textAlign(CENTER);
      text("underbot", width/2, 135);
    break;
  }
}
void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
}

void mousePressed(){
  if(!countbul){
    if(dist(mouseX, mouseY, botpos.x, botpos.y) > 20 && dist(mouseX, mouseY, player.x, player.y) > 20){
      bullets.add(new bullet(mouseX, mouseY, "bot", false));
      countbul = true;
    } else {
      tooclose = 1055;
    }
  }
}

void botcontrol(){
  float distance = dist(nearbotb.x, nearbotb.y, botpos.x, botpos.y);
  float veldiff = abs(abs(nearbotv.x) - abs(nearbotv.y));
  if(distance < 50){
    if(veldiff > 1.05){
      if(nearbotb.x > botpos.x) botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
      if(nearbotb.x < botpos.x) botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
      if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
    } else {
      if(distance < 19){
        if(nearbotb.x > botpos.x) botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
        if(nearbotb.x < botpos.x) botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
        if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
        if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      } else {
        if(nearbotb.x > botpos.x) botpos.x = constrain(botpos.x - 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
        if(nearbotb.x < botpos.x) botpos.x = constrain(botpos.x + 2, width/3*2 - boxsize.x / 2 + bwid + 6, width/3*2 + boxsize.x / 2 - bwid - 5);
        if(nearbotb.y > botpos.y) botpos.y = constrain(botpos.y + 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
        if(nearbotb.y < botpos.y) botpos.y = constrain(botpos.y - 2, 400 - boxsize.y/2 + bwid + 6, 400 + boxsize.y/2 - bwid - 5);
      }
    }
  }
}

class bullet {
  PVector pos;
  PVector vel = new PVector(0, 0);
  String dir = "";
  boolean sti;
  int fc = frameCount;
  bullet(float x, float y, String directed, boolean still){
    dir = directed;
    sti = still;
    pos = new PVector(x, y);
    setvelocity();
  }
  void setvelocity(){
    switch(dir){
      case "player":
        vel = new PVector(pos.x - player.x, pos.y - player.y);
        if(abs(vel.y) > abs(vel.x)) vel.div(abs(vel.y) / 3);
        if(abs(vel.x) > abs(vel.y)) vel.div(abs(vel.x) / 3);
      break;
      case "bot":
        vel = new PVector(pos.x - botpos.x, pos.y - botpos.y);
        if(abs(vel.y) > abs(vel.x)) vel.div(abs(vel.y) / 3);
        if(abs(vel.x) > abs(vel.y)) vel.div(abs(vel.x) / 3);
      break;
    }
    if(sti) vel = new PVector(0, 0);
  }
  void run(){
    noStroke();
    fill(255);
    if(sti) fill(255, 0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate((frameCount % 365) / 4);
    ellipse(0, 0, 10, 6);
    popMatrix();
    
    if(frameCount - fc > 45) pos.sub(vel);
    if(frameCount - fc == 30) setvelocity();
  }
}

void runbullets(){
  float nearness = 999;
  int nearindex = 0;
  float nearnessb = 999;
  int nearindb = 0;
  for(int i = 0; i < bullets.size(); i++){
    bullet b = bullets.get(i);
    b.run();
    if(dist(b.pos.x, b.pos.y, player.x, player.y) < 10){
      hp -= 1;
      hp = constrain(hp, 0, 84);
      bullets.remove(i);
      heartcolour = 255;
    }
    if(dist(b.pos.x, b.pos.y, player.x, player.y) < nearness){
      nearness = dist(b.pos.x, b.pos.y, player.x, player.y);
      nearindex = i;
    }
    
    if(dist(b.pos.x, b.pos.y, botpos.x, botpos.y) < 10){
      bhp -= 1;
      bhp = constrain(bhp, 0, 126);
      bullets.remove(i);
      botcol = -155;
    }
    if(dist(b.pos.x, b.pos.y, botpos.x, botpos.y) < nearnessb){
      nearnessb = dist(b.pos.x, b.pos.y, botpos.x, botpos.y);
      nearindb = i;
    }
    
    if(dist(b.pos.x, b.pos.y, width/2, 400) > width / 2){
      bullets.remove(i);
    }
  }
  if(bullets.size() > 0 && nearindex < bullets.size()){
    nearbullet.x = bullets.get(nearindex).pos.x;
    nearbullet.y = bullets.get(nearindex).pos.y;
    
    nearvel.x = bullets.get(nearindex).vel.x;
    nearvel.y = bullets.get(nearindex).vel.y;
  }
  
  if(bullets.size() > 0 && nearindb < bullets.size()){
    nearbotb.x = bullets.get(nearindb).pos.x;
    nearbotb.y = bullets.get(nearindb).pos.y;
    
    nearbotv.x = bullets.get(nearindb).vel.x;
    nearbotv.y = bullets.get(nearindb).vel.y;
  }
}

void spawnbullets(){
  if(frameCount % 18 == 0){
    bullets.add(new bullet(random(width/3-150, width/3+150), random(250, 550), "player", false));
  }
  
  streambullets("bottom", 3200, 200, 0, "player");
  streambullets("top", 3200, 1000, 0, "player");
  
  if(frameCount % 3200 == 2300) bigburst(0, "player");
  if(frameCount % 3200 == 2360) littleburst(0, "player");
  
  streamcnt = constrain(streamcnt+1, 0, 900);
  bburstcnt = constrain(bburstcnt+1, 0, 1200);
  lburstcnt = constrain(lburstcnt+1, 0, 1200);
}

void streambullets(String place, int interval, int displace, int shift, String direct){
  if(place == "bottom"){
    if(frameCount % interval == 0 + displace) bullets.add(new bullet(width/3+shift-100, 400+120, direct, false));
    if(frameCount % interval == 3 + displace) bullets.add(new bullet(width/3+shift-80, 400+120, direct, false));
    if(frameCount % interval == 6 + displace) bullets.add(new bullet(width/3+shift-60, 400+120, direct, false));
    if(frameCount % interval == 9 + displace) bullets.add(new bullet(width/3+shift-40, 400+120, direct, false));
    if(frameCount % interval == 12 + displace) bullets.add(new bullet(width/3+shift-20, 400+120, direct, false));
    if(frameCount % interval == 15 + displace) bullets.add(new bullet(width/3+shift, 400+120, direct, false));
    if(frameCount % interval == 18 + displace) bullets.add(new bullet(width/3+shift+20, 400+120, direct, false));
    if(frameCount % interval == 21 + displace) bullets.add(new bullet(width/3+shift+40, 400+120, direct, false));
    if(frameCount % interval == 24 + displace) bullets.add(new bullet(width/3+shift+60, 400+120, direct, false));
    if(frameCount % interval == 27 + displace) bullets.add(new bullet(width/3+shift+80, 400+120, direct, false));
    if(frameCount % interval == 30 + displace) bullets.add(new bullet(width/3+shift+100, 400+120, direct, false));
  }
  if(place == "top"){
    if(frameCount % interval == 0 + displace) bullets.add(new bullet(width/3+shift-100, 400-120, direct, false));
    if(frameCount % interval == 3 + displace) bullets.add(new bullet(width/3+shift-80, 400-120, direct, false));
    if(frameCount % interval == 6 + displace) bullets.add(new bullet(width/3+shift-60, 400-120, direct, false));
    if(frameCount % interval == 9 + displace) bullets.add(new bullet(width/3+shift-40, 400-120, direct, false));
    if(frameCount % interval == 12 + displace) bullets.add(new bullet(width/3+shift-20, 400-120, direct, false));
    if(frameCount % interval == 15 + displace) bullets.add(new bullet(width/3+shift, 400-120, direct, false));
    if(frameCount % interval == 18 + displace) bullets.add(new bullet(width/3+shift+20, 400-120, direct, false));
    if(frameCount % interval == 21 + displace) bullets.add(new bullet(width/3+shift+40, 400-120, direct, false));
    if(frameCount % interval == 24 + displace) bullets.add(new bullet(width/3+shift+60, 400-120, direct, false));
    if(frameCount % interval == 27 + displace) bullets.add(new bullet(width/3+shift+80, 400-120, direct, false));
    if(frameCount % interval == 30 + displace) bullets.add(new bullet(width/3+shift+100, 400-120, direct, false));
  }
}

void streambulletsbot(String place, int shift, String direct, int cnt){
  if(place == "bottom"){
    if(frameCount - cnt == 0) bullets.add(new bullet(width/3+shift-100, 400+120, direct, false));
    if(frameCount - cnt == 3) bullets.add(new bullet(width/3+shift-80, 400+120, direct, false));
    if(frameCount - cnt == 6) bullets.add(new bullet(width/3+shift-60, 400+120, direct, false));
    if(frameCount - cnt == 9) bullets.add(new bullet(width/3+shift-40, 400+120, direct, false));
    if(frameCount - cnt == 12) bullets.add(new bullet(width/3+shift-20, 400+120, direct, false));
    if(frameCount - cnt == 15) bullets.add(new bullet(width/3+shift, 400+120, direct, false));
    if(frameCount - cnt == 18) bullets.add(new bullet(width/3+shift+20, 400+120, direct, false));
    if(frameCount - cnt == 21) bullets.add(new bullet(width/3+shift+40, 400+120, direct, false));
    if(frameCount - cnt == 24) bullets.add(new bullet(width/3+shift+60, 400+120, direct, false));
    if(frameCount - cnt == 27) bullets.add(new bullet(width/3+shift+80, 400+120, direct, false));
    if(frameCount - cnt == 30) bullets.add(new bullet(width/3+shift+100, 400+120, direct, false));
  }
  if(place == "top"){
    if(frameCount - cnt == 0) bullets.add(new bullet(width/3+shift-100, 400-120, direct, false));
    if(frameCount - cnt == 3) bullets.add(new bullet(width/3+shift-80, 400-120, direct, false));
    if(frameCount - cnt == 6) bullets.add(new bullet(width/3+shift-60, 400-120, direct, false));
    if(frameCount - cnt == 9) bullets.add(new bullet(width/3+shift-40, 400-120, direct, false));
    if(frameCount - cnt == 12) bullets.add(new bullet(width/3+shift-20, 400-120, direct, false));
    if(frameCount - cnt == 15) bullets.add(new bullet(width/3+shift, 400-120, direct, false));
    if(frameCount - cnt == 18) bullets.add(new bullet(width/3+shift+20, 400-120, direct, false));
    if(frameCount - cnt == 21) bullets.add(new bullet(width/3+shift+40, 400-120, direct, false));
    if(frameCount - cnt == 24) bullets.add(new bullet(width/3+shift+60, 400-120, direct, false));
    if(frameCount - cnt == 27) bullets.add(new bullet(width/3+shift+80, 400-120, direct, false));
    if(frameCount - cnt == 30) bullets.add(new bullet(width/3+shift+100, 400-120, direct, false));
  }
}

void bigburst(int shift, String direct){
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift+i, 400-120, direct, false));
  }
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift+i, 400+120, direct, false));
  }
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift-120, 400+i, direct, false));
  }
  for(int i = -100; i < 101; i += 100){
    bullets.add(new bullet(width/3+shift+120, 400+i, direct, false));
  }
}
void littleburst(int shift, String direct){
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift+i, 400-120, direct, false));
  }
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift+i, 400+120, direct, false));
  }
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift-120, 400+i, direct, false));
  }
  for(int i = -40; i < 41; i += 40){
    bullets.add(new bullet(width/3+shift+120, 400+i, direct, false));
  }
}

int randomize;
void buttons(){
  noFill();
  strokeWeight(2);
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2-75, 75) < 30){ 
    stroke(255);
    if(mousePressed && streamcnt == 900){
      randomize = round(random(1));
      currfc = frameCount;
      cntstr = true;
      streamcnt = 0;
    }
  }
  if(cntstr == true && frameCount - currfc < 32){
    if(randomize == 1) streambulletsbot("bottom", width/3, "bot", currfc);
    if(randomize == 0) streambulletsbot("top", width/3, "bot", currfc);
  }
  if(frameCount - currfc > 31){
    cntstr = false;
  }
  
  ellipse(width/2-75, 75, 60, 60);
  
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2, 75) < 30){ 
    stroke(255);
    if(mousePressed && bburstcnt == 1200){
      bburstcnt = 0;
      bigburst(width/3, "bot");
    }
  }
  ellipse(width/2, 75, 60, 60);
  
  stroke(255, 100);
  if(dist(mouseX, mouseY, width/2 + 75, 75) < 30){ 
    stroke(255);
    if(mousePressed && lburstcnt == 1200){
      lburstcnt = 0;
      littleburst(width/3, "bot");
    }
  }
  ellipse(width/2 + 75, 75, 60, 60);
  
  rectMode(CORNER);
  noStroke();
  fill(255, 127);
  rect(width/2 - 100, 15, 50, 20);
  rect(width/2 - 25, 15, 50, 20);
  rect(width/2 + 50, 15, 50, 20);
  
  rect(width/2 - 100, 15, streamcnt / 18, 20);
  rect(width/2 - 25, 15, bburstcnt / 24, 20);
  rect(width/2 + 50, 15, lburstcnt / 24, 20);
}

void heart (){
  noStroke();
  fill(255 - heartcolour, 0, 0);
  beginShape();
  vertex(player.x, player.y - 4);
  vertex(player.x + 1, player.y - 4);
  vertex(player.x + 1, player.y - 6);
  vertex(player.x + 2, player.y - 6);
  vertex(player.x + 2, player.y - 7);
  vertex(player.x + 4, player.y - 7);
  vertex(player.x + 4, player.y - 8);
  vertex(player.x + 6, player.y - 8);
  vertex(player.x + 6, player.y - 7);
  vertex(player.x + 7, player.y - 7);
  vertex(player.x + 7, player.y - 6);
  vertex(player.x + 8, player.y - 6);
  vertex(player.x + 8, player.y + 2);
  vertex(player.x + 6, player.y + 2);
  vertex(player.x + 6, player.y + 4);
  vertex(player.x + 4, player.y + 4);
  vertex(player.x + 4, player.y + 6);
  vertex(player.x + 2, player.y + 6);
  vertex(player.x + 2, player.y + 8);
  vertex(player.x, player.y + 8);
  endShape();
  rectMode(CORNER);
  rect(player.x - 1, player.y - 4, 2, 12);
  rectMode(CENTER);
  beginShape();
  vertex(player.x, player.y - 4);
  vertex(player.x - 1, player.y - 4);
  vertex(player.x - 1, player.y - 6);
  vertex(player.x - 2, player.y - 6);
  vertex(player.x - 2, player.y - 7);
  vertex(player.x - 4, player.y - 7);
  vertex(player.x - 4, player.y - 8);
  vertex(player.x - 6, player.y - 8);
  vertex(player.x - 6, player.y - 7);
  vertex(player.x - 7, player.y - 7);
  vertex(player.x - 7, player.y - 6);
  vertex(player.x - 8, player.y - 6);
  vertex(player.x - 8, player.y + 2);
  vertex(player.x - 6, player.y + 2);
  vertex(player.x - 6, player.y + 4);
  vertex(player.x - 4, player.y + 4);
  vertex(player.x - 4, player.y + 6);
  vertex(player.x - 2, player.y + 6);
  vertex(player.x - 2, player.y + 8);
  vertex(player.x, player.y + 8);
  endShape();
  
  heartcolour *= 0.9;
}

void botheart(){
  noStroke();
  fill(botcol+155, botcol+155, botcol+155);
  beginShape();
  vertex(botpos.x, botpos.y - 4);
  vertex(botpos.x + 1, botpos.y - 4);
  vertex(botpos.x + 1, botpos.y - 6);
  vertex(botpos.x + 2, botpos.y - 6);
  vertex(botpos.x + 2, botpos.y - 7);
  vertex(botpos.x + 4, botpos.y - 7);
  vertex(botpos.x + 4, botpos.y - 8);
  vertex(botpos.x + 6, botpos.y - 8);
  vertex(botpos.x + 6, botpos.y - 7);
  vertex(botpos.x + 7, botpos.y - 7);
  vertex(botpos.x + 7, botpos.y - 6);
  vertex(botpos.x + 8, botpos.y - 6);
  vertex(botpos.x + 8, botpos.y + 2);
  vertex(botpos.x + 6, botpos.y + 2);
  vertex(botpos.x + 6, botpos.y + 4);
  vertex(botpos.x + 4, botpos.y + 4);
  vertex(botpos.x + 4, botpos.y + 6);
  vertex(botpos.x + 2, botpos.y + 6);
  vertex(botpos.x + 2, botpos.y + 8);
  vertex(botpos.x, botpos.y + 8);
  endShape();
  rectMode(CORNER);
  rect(botpos.x - 1, botpos.y - 4, 2, 12);
  rectMode(CENTER);
  beginShape();
  vertex(botpos.x, botpos.y - 4);
  vertex(botpos.x - 1, botpos.y - 4);
  vertex(botpos.x - 1, botpos.y - 6);
  vertex(botpos.x - 2, botpos.y - 6);
  vertex(botpos.x - 2, botpos.y - 7);
  vertex(botpos.x - 4, botpos.y - 7);
  vertex(botpos.x - 4, botpos.y - 8);
  vertex(botpos.x - 6, botpos.y - 8);
  vertex(botpos.x - 6, botpos.y - 7);
  vertex(botpos.x - 7, botpos.y - 7);
  vertex(botpos.x - 7, botpos.y - 6);
  vertex(botpos.x - 8, botpos.y - 6);
  vertex(botpos.x - 8, botpos.y + 2);
  vertex(botpos.x - 6, botpos.y + 2);
  vertex(botpos.x - 6, botpos.y + 4);
  vertex(botpos.x - 4, botpos.y + 4);
  vertex(botpos.x - 4, botpos.y + 6);
  vertex(botpos.x - 2, botpos.y + 6);
  vertex(botpos.x - 2, botpos.y + 8);
  vertex(botpos.x, botpos.y + 8);
  endShape();
  
  botcol *= 0.9;
}

void closelines(){
  noFill();
  stroke(255, tooclose);
  strokeWeight(2);
  ellipse(player.x-1, player.y-1, 40, 40);
  ellipse(botpos.x-1, botpos.y-1, 40, 40);
  
  tooclose *= 0.94;
}