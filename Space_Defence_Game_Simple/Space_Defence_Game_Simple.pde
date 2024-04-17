// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxLives = 5;
float stationSizeX = 140;
float stationSizeY = 80;
color stationOriginalColor = color(150, 150, 150);
float targetSizeX = 70;
float targetSizeY = 30;
float minTargetSpeed = 0.5;
int maxTargetSpeed = 5;

float xHairSizeX = 3;
float xHairSizeY = 20;
int xHairGap = 10;
color xHairColor = color(255, 255, 255);

// ===== BACKGROUND OBJECT SETTINGS =====
float lShipSizeX = 300; // 1 : 2.5 aspect ratio
float lShipSizeY = 120;
float lShipPosX;
float lShipPosY;

float rShipSizeX = 300;
float rShipSizeY = 120;
float rShipPosX;
float rShipPosY;

int starCount = 150;
float[] gStarPositionsX = new float[starCount];
float[] gStarPositionsY = new float[starCount];
float[] gStarSizes = new float[starCount];
color[] gStarColors = new color[starCount];

color[] starColors = {
  color(255, 255, 255),
  color(217, 243, 255),
  color(190, 229, 247),
  color(250, 222, 65),
  color(250, 167, 65),
  color(252, 123, 58),
  color(252, 81, 58),
};

int moonSize = 200;
int craterCount = 15;
int craterMaxSize = 40;
int craterMinSize = 10;
float moonPosX;
float moonPosY;
float[] craterPositionsX = new float[craterCount];
float[] craterPositionsY = new float[craterCount];
float[] craterSizes = new float[craterCount];

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

float mousePosX;
float mousePosY;

float centrePosX;
float centrePosY;

float targetPosX;
float targetPosY;
float targetVelocityX;
float targetVelocityY;
int targetType; // 0 == enemy, 1 == friendly
boolean targetAlive;
float currentTargetSpeed;
color stationColor;

void setup() {
  noCursor();
  size(800, 600);
  centrePosX = width * 0.5;
  centrePosY = height * 0.5 + infoAreaY * 0.5;
  lShipPosX = 180;
  lShipPosY = 200;
  rShipPosX = width - 180;
  rShipPosY = 180;
  stationColor = stationOriginalColor;
  generateStars();
}

void draw() {
  background(0);
  drawStars();
  
  if (gameState == 2) {
    drawEndScreen();
    return;
  }
  
  if (gameState == 0) {
    drawStartScreen();
    return;
  }
  
  mousePosX = mouseX;
  mousePosY = max(mouseY, infoAreaY);
  
  if(!targetAlive) {
    spawnTarget();
  }

  currentTargetSpeed += 0.001; // Make the difficulty ramp up over time
  
  drawBackgroundObjects();
  runTarget();
  drawCrosshair();
  drawInfoArea();
  
  millisPassed += millis() - lastMilli;
  lastMilli = millis();
}

void mousePressed() {
  if (gameState != 1) {
    return;  
  }
  
  shotsTaken++;
  stroke(250, 210, 0);
  strokeWeight(3);
  line(centrePosX + stationSizeX * 0.025 + 3, centrePosY - stationSizeY * 0.15 + 3, mousePosX, mousePosY);
  if (checkCollision(targetPosX, targetPosY, targetSizeX, targetSizeY, mousePosX, mousePosY)) {
    shotsHit++;
    incrementScore();
    killTarget();
  } else {
    removeLives();  
  }
}


void keyPressed() {
  if (gameState == 2) {
    if (key == 'r') { // Start new round from end screen
      newRound();  
    }
    if (key == 'm') {
      gameState = 0; // Return to menu from end screen
    }
    if (key == 'q') { // Quit game from end screen
      exit();
    }
  }
  
  if(gameState == 0) {
    if (key == 'q') { // Quit game from start seceen
      exit();
    }
    if (key == 's') { // Start new round from start screen
      newRound();  
    }
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
  generateMoon();
  currentTargetSpeed = minTargetSpeed;
  gameState = 1;
}

void endRound() {
  gameState = 2;
}

void removeLives() {
  lives--;
  stationColor = color(200, 0, 0);
  if (lives <= 0) {
    endRound();  
  }
}

void incrementScore() {
  if(targetType == 0) {
    kills++;
    score += 4;
  } else {
    score --;
  }
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    gStarPositionsX[i] = random(width);
    gStarPositionsY[i] = random(height);
    gStarColors[i] = starColors[floor(random(starColors.length))];
    gStarSizes[i] = random(1, 3);
  }
}

void generateMoon() {
  moonPosX = width * 0.85;
  moonPosY = height * 0.75;
  for (int i = 0; i < craterCount; i++) {
    float craterSize = random(craterMinSize, craterMaxSize);
    float magnitude = moonSize / random(2, 4) - craterSize / 2;
    float[] pos = vectorSetMag(random(-1, 1), random(-1, 1), magnitude);
    craterPositionsX[i] = moonPosX + pos[0];
    craterPositionsY[i] = moonPosY + pos[1];
    craterSizes[i] = craterSize;
  }
}

// Needed to make my own vector functions to avoid using PVector
float[] vectorNormalize(float x, float y) { // Converts a vector into its unit form with a magnitude of 1
  float m = vectorGetMag(x, y);
  return new float[] {x / m, y / m};
}

float vectorGetMag(float x, float y) { // Uses pythag to get the hypotenuse of the vector
  return sqrt(pow(x, 2) + pow(y, 2));  
}

float[] vectorSetMag(float x, float y, float m) { // Normalizes vector before magnitude is applied to keep correct direction
  float[] nVector = vectorNormalize(x, y);
  return new float[] {nVector[0] * m, nVector[1] * m};
}

boolean checkCollision(float pos1X, float pos1Y, float size1X, float size1Y, float pos2X, float pos2Y, float size2X, float size2Y) {
  // if right x coord of rect 1 is less than the left x coord of rect 2 
  // or the left x coord of rect 1 is greater than the right x coord of rect 2
  if (pos1X + size1X * 0.5 < pos2X - size2X * 0.5 || pos1X - size1X * 0.5 > pos2X + size2X * 0.5) {
    return false; 
  }
  // if bottom y coord of rect 1 is less than the top y coord of rect 2
  // or the top y coord of rect 1 is greater than the bottom y coord of rect 2
  if (pos1Y + size1Y * 0.5 < pos2Y - size2Y * 0.5 || pos1Y - size1Y * 0.5 > pos2Y + size2Y * 0.5) {
    return false; 
  }
  return true;
}

boolean checkCollision(float posX, float posY, float sizeX, float sizeY, float pointX, float pointY) {
  if (pointX < posX - sizeX * 0.5 || pointX > posX + sizeX * 0.5) {
    return false;
  }
  if (pointY < posY - sizeY * 0.5 || pointY > posY + sizeY * 0.5) {
    return false;
  }
  return true;
}

boolean randomBool() {
  return boolean((int)random(2));
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

// ===== TARGET FUNCTIONS ===== 
void spawnTarget() {

  if (randomBool()) { // Spawn along X
    
    if (randomBool()) { // Spawn on Bottom
      targetPosY = height - targetSizeY * 0.5; 
    } else { // Spawn on top
      targetPosY = infoAreaY + targetSizeY * 0.5;
    }
    targetPosX = random(targetSizeX * 0.5, width);
    
  } else { // spawn along Y
    
    if (randomBool()) {
      targetPosX = targetSizeX * 0.5; // Spawn on Left
    } else {
      targetPosX = width - targetSizeX * 0.5; // Spawn on Right
    }
    targetPosY = random(infoAreaY + targetSizeY, height - targetSizeY * 0.5);
  }

  targetType = (int)random(2);
  float[] velocity = vectorSetMag(centrePosX - targetPosX, centrePosY - targetPosY, currentTargetSpeed);
  targetVelocityX = velocity[0];
  targetVelocityY = velocity[1];
  targetAlive = true;
}

void killTarget() {
  targetAlive = false;
}

void runTarget() {
  if (targetAlive) {
    if(checkCollision(targetPosX, targetPosY, targetSizeX, targetSizeY, centrePosX, centrePosY, stationSizeX, stationSizeY)) {
      killTarget();
      if (targetType == 0) {
        removeLives();
      }
    }
    targetPosX += targetVelocityX;
    targetPosY += targetVelocityY;
    drawTarget();
  }
}

// ===== DRAW FUNCTIONS =====
void drawStartScreen() {
  fill(255, 200, 0);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Space Defender", centrePosX, centrePosY - height * 0.4);
  textSize(20);
  text("Click on enemy ships to destroy them, dont let them reach the space station!\nFriendly ships reduce score if killed.", 
        centrePosX, centrePosY - height * 0.2);
  text("Ship speed increases over time, Missed shots reduce lives.\nKeep good accuracy to get a higher score.\n\nGood Luck!", 
        centrePosX, centrePosY - height * 0.05); 
  textAlign(LEFT);
  text("[s] Start Game", width * 0.05, height * 0.8);
  text("[q] Quit", width * 0.05, height * 0.85);
}

void drawEndScreen() {
  fill(255, 200, 0);  
  textAlign(CENTER);
  textSize(64);
  text("Game Over!", centrePosX, centrePosY - height * 0.4);
  textSize(40);
  text("Score: " + score, centrePosX, centrePosY - height * 0.3);
  text("Kills: " + kills, centrePosX, centrePosY - height * 0.2);
  text("Accuracy: " + calcAccuracy() + "%", centrePosX, centrePosY - height * 0.1);
  text("Time: " + formatMillis(millisPassed), centrePosX, centrePosY);
  text("Final Score: " + ceil(score - (score * ( 1 - (calcAccuracy() / 100.)))), centrePosX, centrePosY + height * 0.1);
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
  text("Space Defender", centrePosX, infoAreaY / 5);
  text(formatMillis(millisPassed), centrePosX, infoAreaY * 0.5);
  text("Score\n" + score, width * 0.05, infoAreaY / 4);
  text("Kills\n" + kills, width * 0.15, infoAreaY / 4);
  text("Accuracy\n " + calcAccuracy() + "%", width * 0.28, infoAreaY * 0.25);
  text("Lives", width * 0.85, infoAreaY / 4);
  
  drawLivesBar(width * 0.85, infoAreaY * 0.6, 20, 20, 30, lives);
}

void drawLivesBar(float posX, float posY, int sizeX, int sizeY, float iconDistance, int lives) {
  float barWidth = sizeX + iconDistance * (lives + 1);
  float barCentre = barWidth * 0.5 - (sizeX * 0.5);
  for (int i = 1; i <= lives; i++) { 
    fill(0, 255, 0);
    rect(posX - sizeX / 2 - barCentre + iconDistance * i, posY, sizeX, sizeY);
  }
}

void drawBackgroundObjects() {
  // Space Station
  stationColor = lerpColor(stationColor, stationOriginalColor, 0.1);
  
  fill(stationColor);
  rect(centrePosX - stationSizeX * 0.5, centrePosY - stationSizeY * 0.2, stationSizeX * 0.3, stationSizeY * 0.6); // Left
  rect(centrePosX + stationSizeX * 0.3, centrePosY - stationSizeY * 0.5, stationSizeX * 0.2, stationSizeY); // Right
  fill(255);
  rect(centrePosX + stationSizeX * 0.35, centrePosY - stationSizeY * 0.4, stationSizeX * 0.1, stationSizeY * 0.8); // Right Light
  fill(stationColor);
  rect(centrePosX, centrePosY - stationSizeY * 0.2, stationSizeX * 0.1, stationSizeY * 0.2); // Middle Top
  fill(250, 210, 0);
  rect(centrePosX + stationSizeX * 0.025, centrePosY - stationSizeY * 0.15, stationSizeX * 0.05, stationSizeY * 0.1); // Laser Origin
  fill(stationColor);
  rect(centrePosX - stationSizeX * 0.45, centrePosY - stationSizeY * 0.5, stationSizeX * 0.05, stationSizeY * 0.4); // Left antenna
  
  if (millis() > lastLightTime + 1000){
    lightOn = !lightOn;
    lastLightTime = millis();
  } 
  
  if (lightOn) {
    fill(0, 255, 0);
  } else {
    fill(100, 100, 100); 
  }
  
  rect(centrePosX - stationSizeX * 0.45, centrePosY - stationSizeY * 0.5, stationSizeX * 0.05, stationSizeY * 0.1); // Left antenna Light
  fill(stationColor);
  rect(centrePosX - stationSizeX * 0.35, centrePosY - stationSizeY * 0.3, stationSizeX * 0.05, stationSizeY * 0.15); // Right antenna
  rect(centrePosX - stationSizeX * 0.2, centrePosY, stationSizeX * 0.5, stationSizeY * 0.25); // Middle Bottom
  
  for (int i = 0; i < 3; i++) { // Left Lights
    float posY = centrePosY + stationSizeY * (0.25 - i * 0.2);
    for (int k = 0; k < 3; k++) {
      float posX = centrePosX - stationSizeX * (0.275 + k * 0.1);
      fill(255);
      rect(posX, posY, stationSizeX * 0.05, stationSizeY * 0.1);
    }
  }

  // Moon
  fill(220, 220, 220);
  circle(moonPosX, moonPosY, 200);
  for (int i = 0; i < craterCount; i++) {
    fill(170, 170, 170); 
    circle(craterPositionsX[i], craterPositionsY[i], craterSizes[i]);  
  }
  
// Left Ship
  fill(140, 130, 130);
  rect(lShipPosX - lShipSizeX * 0.45, lShipPosY, lShipSizeX * 0.2, lShipSizeY * 0.3); // Back
  fill(230, 255, 255);
  rect(lShipPosX - lShipSizeX * 0.45, lShipPosY - lShipSizeY * 0.25, lShipSizeX * 0.15, lShipSizeY * 0.2); // Back Top
  rect(lShipPosX - lShipSizeX * 0.4, lShipPosY - lShipSizeY * 0.5, lShipSizeX * 0.05, lShipSizeY * 0.25); // Back Middle Top
  rect(lShipPosX - lShipSizeX * 0.35, lShipPosY - lShipSizeY * 0.5, lShipSizeX * 0.05, lShipSizeY * 0.1); // Right Top
  triangle( // Back Top
    lShipPosX - lShipSizeX * 0.45, 
    lShipPosY - lShipSizeY * 0.25,
    lShipPosX - lShipSizeX * 0.4, 
    lShipPosY - lShipSizeY * 0.5,
    lShipPosX - lShipSizeX * 0.4, 
    lShipPosY - lShipSizeY * 0.25
  );
  triangle( // Back Top
    lShipPosX - lShipSizeX * 0.35, 
    lShipPosY - lShipSizeY * 0.25,
    lShipPosX - lShipSizeX * 0.35, 
    lShipPosY - lShipSizeY * 0.5,
    lShipPosX - lShipSizeX * 0.3, 
    lShipPosY - lShipSizeY * 0.25
  );
  triangle( // Top Half
    lShipPosX - lShipSizeX * 0.5, 
    lShipPosY - lShipSizeY * 0.2,
    lShipPosX - lShipSizeX * 0.4,
    lShipPosY + lShipSizeY * 0.1,
    lShipPosX + lShipSizeX * 0.5,
    lShipPosY + lShipSizeY * 0.1
   );
  triangle( // Bottom Half
    lShipPosX - lShipSizeX * 0.5, 
    lShipPosY + lShipSizeY * 0.5,
    lShipPosX - lShipSizeX * 0.4,
    lShipPosY + lShipSizeY * 0.2,
    lShipPosX + lShipSizeX * 0.5,
    lShipPosY + lShipSizeY * 0.2
   );
  fill(140, 130, 130);
  triangle(
    lShipPosX - lShipSizeX * 0.38, 
    lShipPosY - lShipSizeY * 0.05,
    lShipPosX - lShipSizeX * 0.38, 
    lShipPosY - lShipSizeY * 0.3,
    lShipPosX - lShipSizeX * 0.12, 
    lShipPosY - lShipSizeY * 0.05
  );

  fill(140, 130, 130);
  rect(lShipPosX - lShipSizeX * 0.4, lShipPosY + lShipSizeY * 0.1, lShipSizeX * 0.8, lShipSizeY * 0.1); // Middle

  // Right Ship
  fill(230, 255, 255);
  rect(rShipPosX - rShipSizeX * 0.4, rShipPosY - rShipSizeY * 0.3, rShipSizeX * 0.12, rShipSizeY * 0.4); // Front
  rect(rShipPosX - rShipSizeX * 0.3, rShipPosY - rShipSizeY * 0.34, rShipSizeX * 0.12, rShipSizeY * 0.65); // Front - 1
  rect(rShipPosX - rShipSizeX * 0.2, rShipPosY - rShipSizeY * 0.425, rShipSizeX * 0.55, rShipSizeY * 0.85); // Middle
  rect(rShipPosX + rShipSizeX * 0.2, rShipPosY - rShipSizeY * 0.5, rShipSizeX * 0.3, rShipSizeY * 0.2); // Top Back
  rect(rShipPosX + rShipSizeX * 0.2, rShipPosY + rShipSizeY * 0.3, rShipSizeX * 0.3, rShipSizeY * 0.2); // Bottom Back
  fill(140, 130, 130);
  rect(rShipPosX - rShipSizeX * 0.5, rShipPosY - rShipSizeY * 0.25, rShipSizeX * 0.1, rShipSizeY * 0.05); // Top Antenna
  rect(rShipPosX - rShipSizeX * 0.48, rShipPosY - rShipSizeY * 0.05, rShipSizeX * 0.08, rShipSizeY * 0.05); // Middle Antenna
  rect(rShipPosX - rShipSizeX * 0.45, rShipPosY + rShipSizeY * 0.2, rShipSizeX * 0.15, rShipSizeY * 0.05); // Bottom Antenna
  rect(rShipPosX + rShipSizeX * 0.35, rShipPosY - rShipSizeY * 0.25, rShipSizeX * 0.1, rShipSizeY * 0.2); // Top Thruster
  rect(rShipPosX + rShipSizeX * 0.35, rShipPosY + rShipSizeY * 0.05, rShipSizeX * 0.1, rShipSizeY * 0.2); // Bottom Thruster
  rect(rShipPosX - rShipSizeX * 0.15, rShipPosY - rShipSizeY * 0.3, rShipSizeX * 0.4, rShipSizeY * 0.2); // Top Middle
  rect(rShipPosX - rShipSizeX * 0.15, rShipPosY + rShipSizeY * 0.1, rShipSizeX * 0.4, rShipSizeY * 0.2); // Bottom Middle
  fill(230, 255, 255);
  triangle( // Top Back
    rShipPosX + rShipSizeX * 0.35, 
    rShipPosY - rShipSizeY * 0.3,
    rShipPosX + rShipSizeX * 0.5, 
    rShipPosY - rShipSizeY * 0.3,  
    rShipPosX + rShipSizeX * 0.35, 
    rShipPosY - rShipSizeY * 0.1
  );
  triangle( // Bottom Back
    rShipPosX + rShipSizeX * 0.35, 
    rShipPosY + rShipSizeY * 0.3,
    rShipPosX + rShipSizeX * 0.5, 
    rShipPosY + rShipSizeY * 0.3,  
    rShipPosX + rShipSizeX * 0.35, 
    rShipPosY + rShipSizeY * 0.1
  );
  
  // Laser effects
  if ((int)random(101) <= 5) {
    float lShipLinePosX = random(lShipPosX - lShipSizeX * 0.5, lShipPosX + lShipSizeX * 0.5);
    float lShipLinePosY = random(lShipPosY, lShipPosY + lShipSizeY * 0.5);
    float rShipLinePosX = random(rShipPosX - rShipSizeX * 0.5, rShipPosX + rShipSizeX * 0.5); 
    float rShipLinePosY =random(rShipPosY - rShipSizeY * 0.5, rShipPosY + rShipSizeY * 0.5);
    
    stroke(0, 255, 0);
    if (randomBool()) {
      fill(255, 85, 0);
      noStroke();
      circle(lShipLinePosX, lShipLinePosY, 20);
      stroke(0, 255, 0);
    } else {
      fill(255, 85, 0);
      noStroke();
      circle(rShipLinePosX, rShipLinePosY, 20);
      stroke(255, 0, 0);
    }
    strokeWeight(3);
    line(lShipLinePosX, lShipLinePosY, rShipLinePosX, rShipLinePosY);
  }
  
}

void drawCrosshair() {
  if (checkCollision(targetPosX, targetPosY, targetSizeX, targetSizeY, mousePosX, mousePosY)) {
    if(targetType == 0) {
      xHairColor = color(255, 0, 0);
    } else {
      xHairColor = color(0, 255, 0); 
    }
  } else {
    xHairColor = color(255, 255, 255); 
  }

  stroke(xHairColor);
  strokeWeight(xHairSizeX);
  line(mousePosX - xHairGap, mousePosY, mousePosX - xHairGap - xHairSizeY, mousePosY); // Left
  line(mousePosX + xHairGap, mousePosY, mousePosX + xHairGap + xHairSizeY, mousePosY); // Right
  line(mousePosX, mousePosY - xHairGap, mousePosX, mousePosY - xHairGap - xHairSizeY); // Top  
  line(mousePosX, mousePosY + xHairGap, mousePosX, mousePosY + xHairGap + xHairSizeY); // Bottom  
  
  noFill();
  circle(mousePosX, mousePosY, xHairSizeY); // Ring
  stroke(250, 210, 0);
  strokeWeight(xHairSizeX * 2);
  point(mousePosX, mousePosY); // Centre
}

void drawStars() {
  for (int i = 0; i < starCount; i++)  {
    fill(gStarColors[i]);
    noStroke();
    circle(gStarPositionsX[i], gStarPositionsY[i], gStarSizes[i]);
  }
}

void drawTarget() {
  float posX = targetPosX;
  float posY = targetPosY;
  float sizeX = targetSizeX;
  float sizeY = targetSizeY;
  
  noStroke();
  if (targetType == 0) {
    fill(150, 150, 150);
    triangle(
      posX - sizeX * 0.5,
      posY - sizeY * 0.2,    
      posX,
      posY - sizeY * 0.5,         
      posX + sizeX * 0.5,
      posY - sizeY * 0.2
    );
    triangle(
      posX + sizeX * 0.5,
      posY + sizeY * 0.2,  
      posX,
      posY + sizeY * 0.5,        
      posX - sizeX * 0.5,
      posY + sizeY * 0.2
    );
    rect(posX - sizeX * 0.15, posY - sizeY * 0.25, sizeX * 0.3, sizeY * 0.5);
    fill(200, 200, 200);
    circle(posX, posY, sizeY * 0.5);
    fill(255, 0, 0);
    rect(posX - sizeX * 0.05, posY - sizeY * 0.1, sizeX * 0.1, sizeY * 0.2);
  } else {
    fill(150, 150, 150);
    ellipse(posX, posY, sizeX, sizeY);
    fill(200, 200, 200);
    rect(posX - sizeX * 0.5, posY - sizeY * 0.2, sizeX, sizeY * 0.4);
    fill(0, 255, 0);
    rect(posX - sizeX * 0.4, posY - sizeY * 0.1, sizeX * 0.2, sizeY * 0.2);    
    rect(posX - sizeX * 0.1, posY - sizeY * 0.1, sizeX * 0.2, sizeY * 0.2);
    rect(posX + sizeX * 0.2, posY - sizeY * 0.1, sizeX * 0.2, sizeY * 0.2);
  }
}
