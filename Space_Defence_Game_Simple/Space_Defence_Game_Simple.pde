// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxLives = 5;
PVector stationSize = new PVector(140, 80);
PVector targetSize =  new PVector(70, 30);
float minShipSpeed = 0.5;
int maxShipSpeed = 10;

PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
color xHairColor = color(255, 255, 255);

// ===== BACKGROUND OBJECT SETTINGS =====
PVector lShipSize = new PVector(300, 120); // 1 : 2.5 aspect ratio
PVector rShipSize = new PVector(300, 120);
PVector lShipPos = new PVector(180, 200);
PVector rShipPos = new PVector(620, 180);

boolean lightOn = false;
int lastLightTime = millis();

// ===== CURRENT ROUND VALUES =====
int gameState = 0; // 0 == start screen, 1 = game screen, 2 = end screen
int score;
int kills;
int lives;

float shotsTaken;
float shotsHit;

int millisPassed;
int lastMilli;

PVector mousePos = new PVector();
PVector centrePos;

PVector targetPosition = new PVector();
PVector targetVelocity = new PVector();
int targetType;
boolean targetAlive;
float currentMaxShipSpeed;

void setup() {
  noCursor();
  size(800, 600);
  centrePos = new PVector(width * 0.5, height * 0.5 + (infoAreaY * 0.5));
  lShipPos = new PVector(180, 200);
  rShipPos = new PVector(width - 180, 180);
}

void draw() {
  background(0);
  
  if (gameState == 2) {
    drawEndScreen();
    return;
  }
  
  if (gameState == 0) {
    drawStartScreen();
    return;
  }
  
  mousePos.x = mouseX;
  mousePos.y = max(mouseY, infoAreaY);
  
  if(!targetAlive) {
    spawnTarget();
  }

  currentMaxShipSpeed += 0.001; // Make the difficulty ramp up over time
  
  runTarget();
  drawBackgroundObjects();
  drawCrosshair();
  drawInfoArea();
  
  millisPassed += millis() - lastMilli;
  lastMilli = millis();
}

void mousePressed() {
  if (gameState != 1) {
    return;  
  }

  stroke(#FCD300);
  strokeWeight(3);
  shotsTaken++;
  line(centrePos.x + stationSize.x * 0.025 + 3, centrePos.y - stationSize.y * 0.15 + 3, mousePos.x, mousePos.y);
  if (checkCollision(targetPosition, targetSize, mousePos)) {
    shotsHit++;
    incrementScore();
    killTarget();
  }
}


void keyPressed() {
  if (gameState == 1) { // No key presses if game is active
    return;  
  }
  
  if (gameState == 2) {
    if (key == 'r') { // Restart game at end screen
      newRound();  
    }
    if (key == 'm') {
      gameState = 0; // Return to menu at end screen
    }
  }
  
  if (gameState == 0) {
    if(key == 's') { // Start new round from start screen
      newRound();  
    }
  }
  
  if (key == 'q') { // Quit game when in start or end screen
    exit();
  }
}

// ===== GAME FUNCTIONS ===== 
void newRound() {
  score = 0;
  kills = 0;
  lives = maxLives;
  shotsTaken = 0;
  shotsHit = 0;
  millisPassed = 0;
  lastMilli = millis();
  targetAlive = false;

  currentMaxShipSpeed = minShipSpeed;
  gameState = 1;
}

void endRound() {
  gameState = 2;
}

void removeLives() {
  lives--;
  if (lives < 0) {
    endRound();  
  }
}

void addLives() {
  lives += min(lives + 1, maxLives);
}

void incrementScore() {
  if(targetType == 0) {
    kills++;
    score += 4;
  } else {
    score --;
  }
}

void spawnTarget() {
  targetType = (int)random(1);
  PVector pos;
  
  if (boolean((int)random(2))) { // spawn on X or Y edges
    float posY;
    if (boolean((int)random(2))) {
      posY = height - targetSize.y * 0.5; // Bottom
    } else {
      posY = infoAreaY + targetSize.y * 0.5; // Top
    }
    pos = new PVector(random(targetSize.x * 0.5, width), posY);
  } else {
    float posX;
    if (boolean((int)random(2))) {
      posX = targetSize.x * 0.5; // Left
    } else {
      posX = width - targetSize.x * 0.5; // Right
    }
    pos = new PVector(posX, random(infoAreaY + targetSize.y, height - targetSize.y * 0.5));
  }

  PVector velocity = PVector.sub(centrePos, pos);
  targetPosition = pos;
  targetVelocity = velocity.setMag(currentMaxShipSpeed);
  targetAlive = true;
}

void killTarget() {
  targetAlive = false;
}

void runTarget() {
  if (targetAlive) {
    if(checkCollision(targetPosition, targetSize, centrePos, stationSize)) {
      killTarget();
    }
    
    targetPosition.add(targetVelocity);
    drawTarget();
  }
}

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(floor(seconds / 60), 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
}

int calcAccuracy() {
  if (shotsTaken == 0) {
    return 0;  
  }
  return round(shotsHit / shotsTaken * 10000) / 100;
}

boolean checkCollision(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  // if right x coord of rect 1 is less than the left x coord of rect 2 
  // or the left x coord of rect 1 is greater than the right x coord of rect 2
  if (pos1.x + size1.x * 0.5 < pos2.x - size2.x * 0.5 || pos1.x - size1.x * 0.5 > pos2.x + size2.x * 0.5) {
    return false; 
  }
  // if bottom y coord of rect 1 is less than the top y coord of rect 2
  // or the top y coord of rect 1 is greater than the bottom y coord of rect 2
  if (pos1.y + size1.y * 0.5 < pos2.y - size2.y * 0.5 || pos1.y - size1.y * 0.5 > pos2.y + size2.y * 0.5) {
    return false; 
  }
  return true;
}

boolean checkCollision(PVector pos, PVector size, PVector point) {
  if (point.x < pos.x - size.x * 0.5 || point.x > pos.x + size.x * 0.5) {
    return false;
  }
  if (point.y < pos.y - size.y * 0.5 || point.y > pos.y + size.y * 0.5) {
    return false;
  }
  return true;
}

// ===== DRAW FUNCTIONS =====
void drawStartScreen() {
  fill(255, 200, 0);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Space Defender", centrePos.x, centrePos.y - height * 0.4);
  textSize(20);
  text("Click on enemy ships to damage them, dont let them reach the space station!\nFriendly ships add lives if they make it to the station, but reduce score if killed.", 
        centrePos.x, centrePos.y - height * 0.25); 
  text("Some ships remove more than one life and are slower, taking more hits to kill.\nThe Carrier and Destroyer appear rarely and are capable of creating additional ships.\n\nGood Luck!", 
        centrePos.x, centrePos.y - height * 0.1);
  textAlign(LEFT);
  text("[s] Start Game", width * 0.05, height * 0.8);
  text("[q] Quit", width * 0.05, height * 0.85);
}

void drawEndScreen() {
  fill(255, 200, 0);  
  textAlign(CENTER);
  textSize(64);
  text("Game Over!", centrePos.x, centrePos.y - height * 0.4);
  textSize(40);
  text("Score: " + score, centrePos.x, centrePos.y - height * 0.3);
  text("Kills: " + kills, centrePos.x, centrePos.y - height * 0.2);
  text("Accuracy: " + calcAccuracy() + "%", centrePos.x, centrePos.y - height * 0.1);
  text("Final Score: " + ceil(score - (score * ( 1 - (calcAccuracy() / 100.)))), centrePos.x, centrePos.y);
  textAlign(LEFT);
  textSize(20);
  text("[r] New Round", width * 0.05, height * 0.8);
  text("[m] Title Screen", width * 0.05, height * 0.85);
  text("[q] Quit", width * 0.05, height * 0.9);
}

void drawInfoArea() {
  noStroke();
  fill(#626262);
  rect(0, 0, width, infoAreaY);
  textSize(24);
  fill(255);
  textAlign(CENTER, TOP);
  text("Space Defender", centrePos.x, infoAreaY / 5);
  text(formatMillis(millisPassed), centrePos.x, infoAreaY * 0.5);
  text("Score\n" + score, width * 0.05, infoAreaY / 4);
  text("Kills\n" + kills, width * 0.15, infoAreaY / 4);
  text("Accuracy\n " + calcAccuracy() + "%", width * 0.28, infoAreaY * 0.25);
  text("Lives", width * 0.85, infoAreaY / 4);
  
  drawLivesBar(width * 0.85, infoAreaY * 0.6, 20, 20, 30, lives);
}

void drawLivesBar(float posX, float posY, int sizeX, int sizeY, float iconDistance, int health) {
  float barWidth = sizeX + iconDistance * (health + 1);
  float barCentre = barWidth * 0.5 - (sizeX * 0.5);
  for (int i = 1; i <= health; i++) { 
    fill(0, 255, 0);
    rect(posX - sizeX / 2 - barCentre + iconDistance * i, posY, sizeX, sizeY);
  }
}

void drawBackgroundObjects() {
  // Space Station
  fill(150, 150, 150);
  rect(centrePos.x - stationSize.x * 0.5, centrePos.y - stationSize.y * 0.2, stationSize.x * 0.3, stationSize.y * 0.6); // Left
  rect(centrePos.x + stationSize.x * 0.3, centrePos.y - stationSize.y * 0.5, stationSize.x * 0.2, stationSize.y); // Right
  fill(255);
  rect(centrePos.x + stationSize.x * 0.35, centrePos.y - stationSize.y * 0.4, stationSize.x * 0.1, stationSize.y * 0.8); // Right Light
  fill(150, 150, 150);
  rect(centrePos.x, centrePos.y - stationSize.y * 0.2, stationSize.x * 0.1, stationSize.y * 0.2); // Middle Top
  fill(#FCD300);
  rect(centrePos.x + stationSize.x * 0.025, centrePos.y - stationSize.y * 0.15, stationSize.x * 0.05, stationSize.y * 0.1); // Laser Origin
  fill(150, 150, 150);
  rect(centrePos.x - stationSize.x * 0.45, centrePos.y - stationSize.y * 0.5, stationSize.x * 0.05, stationSize.y * 0.4); // Left antenna
  
  if (millis() > lastLightTime + 1000){
    lightOn = !lightOn;
    lastLightTime = millis();
  } 
  
  if (lightOn) {
    fill(0, 255, 0);
  } else {
    fill(100, 100, 100); 
  }
  
  rect(centrePos.x - stationSize.x * 0.45, centrePos.y - stationSize.y * 0.5, stationSize.x * 0.05, stationSize.y * 0.1); // Left antenna Light
  fill(150, 150, 150);
  rect(centrePos.x - stationSize.x * 0.35, centrePos.y - stationSize.y * 0.3, stationSize.x * 0.05, stationSize.y * 0.15); // Right antenna
  rect(centrePos.x - stationSize.x * 0.2, centrePos.y, stationSize.x * 0.5, stationSize.y * 0.25); // Middle Bottom
  
  for (int i = 0; i < 3; i++) { // Left Lights
    float posY = centrePos.y + stationSize.y * (0.25 - i * 0.2);
    for (int k = 0; k < 3; k++) {
      float posX = centrePos.x - stationSize.x * (0.275 + k * 0.1);
      fill(255);
      rect(posX, posY, stationSize.x * 0.05, stationSize.y * 0.1);
    }
  }
}

void drawCrosshair() {
  if (checkCollision(targetPosition, targetSize, mousePos)) {
    xHairColor = color(255, 0, 0);
  } else {
    xHairColor = color(255, 255, 255); 
  }

  stroke(xHairColor);
  strokeWeight(xHairSize.x);
  line(mousePos.x - xHairGap, mousePos.y, mousePos.x - xHairGap - xHairSize.y, mousePos.y); // Left
  line(mousePos.x + xHairGap, mousePos.y, mousePos.x + xHairGap + xHairSize.y, mousePos.y); // Right
  line(mousePos.x, mousePos.y - xHairGap, mousePos.x, mousePos.y - xHairGap - xHairSize.y); // Top  
  line(mousePos.x, mousePos.y + xHairGap, mousePos.x, mousePos.y + xHairGap + xHairSize.y); // Bottom  
  
  noFill();
  circle(mousePos.x, mousePos.y, xHairSize.y); // Ring
  point(mousePos.x, mousePos.y); // Centre
}

void drawTarget() {
  PVector pos = targetPosition;
  PVector size = targetSize;
  noStroke();
  fill(150, 150, 150);
  triangle(
    pos.x - size.x * 0.5,
    pos.y - size.y * 0.2,    
    pos.x,
    pos.y - size.y * 0.5,         
    pos.x + size.x * 0.5,
    pos.y - size.y * 0.2
  );
  rect(pos.x - size.x * 0.15, pos.y - size.y * 0.25, size.x * 0.3, size.y * 0.5);
  fill(255, 0, 0);
  rect(pos.x - size.x * 0.05, pos.y - size.y * 0.1, size.x * 0.1, size.y * 0.2);
  fill(150, 150, 150);
  triangle(
    pos.x + size.x * 0.5,
    pos.y + size.y * 0.2,  
    pos.x,
    pos.y + size.y * 0.5,        
    pos.x - size.x * 0.5,
    pos.y + size.y * 0.2
  );
}



/*
Background is the correct size                                            2
There is a start screen                                                   2
User can only move to the game screen when a key is pressed               2
Game screen has 2 sections and at least 4 shapes to add visual interest   6
Score and lives are displayed using variables                             3
Target is a composite shape                                               12
Cross hairs are a composite shape                                         12
Target appears at a random location                                       2
A target is hit if the cross hairs and target collide                     10
If a target is hit it should disappear                                    5
When the target reappears the type of target is randomized                5
When target reappears, its location is randomized                         5
Target and cross hairs should be limited to the game area ONLY            5
All of the target should be confined to the game area                     2
Score and lives update as per the target and if it was a successful hit   6
No key presses should work on the game screen                             2
There is a finite end to game                                             4
When game ends it moves to final screen with detail displayed             4
Pressing a key should bring user back to game screen                      4
Upon returning to game screen, scores and lives reset                     2
Creativity                                                                5
*/

/*
Background(800, 600)
2 sections, 1 for game info, other for game
4 static shapes in background for visual interest
Targets and crosshairs must consist of 5 different shapes with more than 1 color
2 types of target, distinguishable appearance
show score and lives left on top section of screen

Begins with start screen, game starts when key is pressed
target randomly chosen between the 2 types
target appears at random position on games screen not cut off by edges
crosshair follows mouse
clicking mouse counts as shot taken
one target increases score by 4 while the other reduces it by 1
decrement lives if shot has missed
game has finite end
end screen that displays stats and allows restarting of game
*/
