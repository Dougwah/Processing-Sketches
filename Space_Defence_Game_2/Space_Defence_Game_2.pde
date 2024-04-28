// Add 2 more background ships on either side that shoot at targets when they randomly dissapear

// Remake ships as they only face downwards now
// Make menu background

// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxLives = 20;
int targetCount = 5;

// Crosshair
PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
color xHairColor = color(255);

// Targets
int[] targetKillScoreValues = {4, -1};
int[] targetExpireScoreValues = {-2, 2}; // Point awards when targets die randomly or when touching the planet
int[] targetDamageValues = {-1, 1}; // Friendlies add lives when they make it to the planet
int targetMinLifeTime = 2;
int targetMaxLifeTime = 8;
float targetMinSpeed = 1;
float targetMaxSpeed = 2.5;
PVector[] targetSizeValues = {
  new PVector(40, 60),
  new PVector(50, 70)
};
int friendlySpawnChance = 25;

// ===== BACKGROUND OBJECT SETTINGS =====

// Far Background Ships
int farShipCount = 8;
PVector[] farShipSizes = {
  new PVector(100, 40), // 1 : 2.5 aspect ratio
  new PVector(100, 40)
};
PVector[][] farShipBounds = new PVector[farShipCount][farShipCount];

// Close Background Ships
PVector leftShipSize = new PVector(100, 60);
PVector rightShipSize = new PVector(100, 100);

// Stars
int starCount = 400;
color[] starColorList = {
  color(255, 255, 255),
  color(217, 243, 255),
  color(190, 229, 247),
  color(250, 222, 65),
  color(250, 167, 65),
  color(252, 123, 58),
  color(252, 81, 58),
};

// Moon
int moonSize = 100;
int craterCount = 15;
int craterMaxSize = 20;
int craterMinSize = 10;

// PlyShip
PVector plyShipSize = new PVector(50, 60);

// Station
PVector stationSize = new PVector(70, 40);
PVector stationPos;
boolean lightOn = false;
int lastLightTime = millis();

// Planet
PVector planetSize;
PVector planetPos;

// Menu Background

// ===== CURRENT ROUND VALUES =====

// Game
int gameState = 0; // 0 == start screen, 1 = game screen, 2 = end screen
int millisPassed;
int lastMilli;
PVector centrePos;

// Player
int score;
int kills;
int lives;
float shotsTaken;
float shotsHit;
PVector mousePos = new PVector(); // Make instance here instead of the draw function
PVector plyShipPos;

// Targets
int[] targetTypes = new int[targetCount];
PVector[] targetPositions = new PVector[targetCount];
PVector[] targetVelocities = new PVector[targetCount];
boolean[] targetStates = new boolean[targetCount];
int[] targetSpawnTimes = new int[targetCount];
int[] targetLifeTimes = new int[targetCount];

// Stars
PVector[] starPositions = new PVector[starCount];
float[] starSizes = new float[starCount];
color[] starColors = new color[starCount];

// Moon
PVector moonPos;
PVector[] craterPositions = new PVector[craterCount];
float[] craterSizes = new float[craterCount];

// Far Background Ships
PVector[] farShipPositions = new PVector[farShipCount];

// Close Background Ships
PVector leftShipPos;
PVector rightShipPos;

// ===== PROCESSING FUNCTIONS =====

void setup() {
  noCursor();
  size(800, 600);
  centrePos = new PVector(width * 0.5, height * 0.5 + infoAreaY * 0.5);
  stationPos = new PVector(width * 0.65, height * 0.6);
  moonPos = new PVector(width * 0.5, height * 0.6);
  leftShipPos = new PVector(width * 0.1, height * 0.65);
  rightShipPos = new PVector(width * 0.9, height * 0.65);
  plyShipPos = new PVector(0, height * 0.8);
  planetPos = new PVector(width * 0.5, height * 1.1);
  planetSize = new PVector(width * 2.2, height * 0.5); 
  
  farShipBounds[0] = new PVector[] { // Ships on the left
    new PVector(farShipSizes[0].x * 0.5, infoAreaY + farShipSizes[0].y * 0.5), // Minimum Coords
    new PVector(width * 0.5 - farShipSizes[0].x, height * 0.4 - farShipSizes[0].y * 0.5) // Maximum Coords
  };
  farShipBounds[1] = new PVector[] { // Ships on the right
    new PVector(width * 0.5 + farShipSizes[1].x * 0.5, infoAreaY + farShipSizes[1].y * 0.5),
    new PVector(width - farShipSizes[1].x * 0.5, height * 0.4 - farShipSizes[1].y * 0.5)
  };
}

void draw() {
  background(0);
  
  if (gameState == 2) {
    drawEndScreen();
  }
  
  if (gameState == 0) {
    drawStartScreen();
  }
  
  if (gameState == 1) {
    mousePos.x = mouseX;
    mousePos.y = max(mouseY, infoAreaY);
    plyShipPos.x = constrain(mouseX, plyShipSize.x * 0.5, width - plyShipSize.x * 0.5);
     
    drawStars();
    drawMoon();
    drawPlanet();
    drawSpaceStation();
    drawFarShips();
    drawCloseShips();
    drawPlyShip();
    
    runTargets();
    drawCrosshair();
    drawInfoArea();
    
    millisPassed += millis() - lastMilli;
    lastMilli = millis();
  }
}

void mousePressed() {
 if (gameState == 1) {
    shotsTaken++;
    drawShot(new PVector(plyShipPos.x - plyShipSize.x * 0.35, plyShipPos.y - plyShipSize.y * 0.3), mousePos, color(250, 210, 0));
    drawShot(new PVector(plyShipPos.x + plyShipSize.x * 0.35, plyShipPos.y - plyShipSize.y * 0.3), mousePos, color(250, 210, 0));
    boolean targetHit = false;
    for(int i = 0; i < targetCount; i++) {
      int type = targetTypes[i];
      if (checkCollision(targetPositions[i], targetSizeValues[type], mousePos)) {
        targetHit = true;
        killTarget(i);
      }
    }
    if (targetHit) {
      shotsHit++;  
    } else {
      updateLives(-1);  
    }
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
  
  if (gameState == 0) {
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
  generateFarShips();
  generateMoonCraters();
  generateStars();
  gameState = 1;
}

void endRound() {
  gameState = 2;
}

void updateLives(int _lives) {
  //lives = min(maxLives, lives + _lives);
  if (lives <= 0) {
    endRound();  
  }
}

void updateScore(int _score) {
  score += _score;
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    starPositions[i] = new PVector((int)random(width), (int)random(infoAreaY, height));
    starColors[i] = starColorList[floor(random(starColorList.length))];
    starSizes[i] = random(1, 3);
  }
}

void generateMoonCraters() {
  for (int i = 0; i < craterCount; i++) {
    float craterSize = random(craterMinSize, craterMaxSize);
    float magnitude = moonSize / random(2, 4) - craterSize * 0.5;
    PVector relativePos = new PVector(random(-1, 1), random(-1, 1)).setMag(magnitude);
    craterPositions[i] = PVector.add(moonPos, relativePos);
    craterSizes[i] = craterSize;
  }
}

void generateFarShips() {
  int lastY = (int)(farShipBounds[0][0].y + random(0, 60));  for(int i = 0; i < farShipCount / 2; i++) {
    farShipPositions[i] = new PVector((int)random(farShipBounds[0][0].x, farShipBounds[0][1].x), lastY);
    lastY += farShipSizes[0].y + (int)random(0, 20);
  }
  
  lastY = (int)(farShipBounds[1][0].y + random(0, 60));
  for(int i = farShipCount / 2; i < farShipCount; i++) {
    farShipPositions[i] = new PVector((int)random(farShipBounds[1][0].x, farShipBounds[1][1].x), lastY);
    lastY += farShipSizes[1].y + (int)random(0, 20); 
  }
}

// Ellipse overlap collision
boolean checkCollision(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  if (abs(pos1.x - pos2.x) < abs((size1.x + size2.x) / 2) && abs(pos1.y - pos2.y) < abs((size1.y + size2.y) / 2)) {
    return true;
  }
  return false;
}

// Rectangular overlap with point
boolean checkCollision(PVector pos, PVector size, PVector point) {
  if (point.x < pos.x - size.x * 0.5 || point.x > pos.x + size.x * 0.5) {
    return false;
  }
  if (point.y < pos.y - size.y * 0.5 || point.y > pos.y + size.y * 0.5) {
    return false;
  }
  return true;
}

boolean randomBool() {
  return boolean((int)random(2));
}

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(seconds / 60, 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
}

int calcAccuracy() {
  if (shotsTaken == 0) {
    return 0;  
  }
  return round(shotsHit / shotsTaken * 100);
}

// ===== TARGET FUNCTIONS =====

void runTargets() {
  for(int i = 0; i < targetCount; i++) {
    int type = targetTypes[i];
    PVector pos = targetPositions[i];
    if (targetStates[i]) {
      target(pos.x, pos.y, type);
      pos.add(targetVelocities[i]);
      
      if (checkCollision(pos, targetSizeValues[type], planetPos, planetSize)) {
        despawnTarget(i);
        updateLives(targetDamageValues[type]);
      }
      
      if (millis() > targetSpawnTimes[i] + targetLifeTimes[i]) {
        drawShot(centrePos, targetPositions[i], color(255, 0, 0));
        despawnTarget(i);
      }
      
    } else {
      spawnTarget(i);
    }
  }
}

void spawnTarget(int index) {
  PVector pos = new PVector();
  
  int type = 0;
  if ((int)random(101) <= friendlySpawnChance) {
    type = 1;
  }
  
  PVector size = targetSizeValues[type];
  
  if (randomBool()) { // Spawn along X
    
    pos.y = infoAreaY + size.y * 0.5;
    pos.x = random(size.x * 0.5, width);
    
  } else { // spawn along Y
    
    if (randomBool()) {
      pos.x = size.x * 0.5; // Spawn on Left
    } else {
      pos.x = width - size.x * 0.5; // Spawn on Right
    }
    pos.y = random(infoAreaY + size.y, height * 0.5 - size.y * 0.5);
  }
  
  targetTypes[index] = type;
  targetPositions[index] = pos;
  targetVelocities[index] = PVector.sub(planetPos, pos).normalize().setMag(random(targetMinSpeed, targetMaxSpeed));
  targetSpawnTimes[index] = millis();
  targetLifeTimes[index] = (int)(random(targetMinLifeTime, targetMaxLifeTime) * 1000);
  targetStates[index] = true;
}

void despawnTarget(int index) { 
  targetStates[index] = false;
}

void killTarget(int index) {
  int type = targetTypes[index];
  if (type == 0) {
    kills++;
  }
  updateScore(targetKillScoreValues[type]);
  despawnTarget(index);
}

// ===== DRAW FUNCTIONS =====

void target(float x, float y, int typeOfTarget) {
  PVector size = targetSizeValues[typeOfTarget];
  noStroke();
  if (typeOfTarget == 0) { // Enemy
    fill(140, 130, 130);
    rect(x - size.x * 0.2, y - size.y * 0.25, size.x * 0.4, size.y * 0.4); // Middle
    fill(180, 0, 0);
    rect(x - size.x * 0.4, y + size.y * 0.1, size.x * 0.1, size.y * 0.3); // left Gun
    rect(x + size.x * 0.3, y + size.y * 0.1, size.x * 0.1, size.y * 0.3); // Right Gun
    fill(80);
    triangle( // Top Left
      x - size.x * 0.5, y - size.y * 0.1,
      x - size.x * 0.2, y - size.y * 0.5,
      x - size.x * 0.2, y - size.y * 0.1
    );
    triangle( // Top Right
      x + size.x * 0.2, y - size.y * 0.1,
      x + size.x * 0.2, y - size.y * 0.5,
      x + size.x * 0.5, y - size.y * 0.1
    );
    triangle( // Bottom Left
      x - size.x * 0.5, y - size.y * 0.1,
      x - size.x * 0.2, y + size.y * 0.5,
      x - size.x * 0.2, y - size.y * 0.1
    );
    triangle( // Bottom Right
      x + size.x * 0.2, y - size.y * 0.1,
      x + size.x * 0.2, y + size.y * 0.5,
      x + size.x * 0.5, y - size.y * 0.1
    );
    fill(180, 0, 0);
    triangle( // Glass
      x, y + size.y * 0.1,
      x - size.x * 0.2, y - size.y * 0.2,
      x + size.x * 0.2, y - size.y * 0.2
    );
    
  } else { // Friendly
 
    fill(80);
    rect(x - size.x * 0.25, y - size.y * 0.25, size.x * 0.5, size.y * 0.4); // Middle
    rect(x - size.x * 0.5, y - size.y * 0.5, size.x * 0.25, size.y * 0.5); // Top Left
    rect(x + size.x * 0.25, y - size.y * 0.5, size.x * 0.25, size.y * 0.5); // Top Right
    rect(x - size.x * 0.1, y + size.y * 0.1, size.x * 0.2, size.y * 0.4); // Bottom Middle
    fill(255, 195, 40);
    triangle( // Bottom Left
      x - size.x * 0.1, y + size.y * 0.5,
      x - size.x * 0.25, y + size.y * 0.15,
      x - size.x * 0.1, y + size.y * 0.15
    );
    triangle( // Bottom Right
      x + size.x * 0.1, y + size.y * 0.5,
      x + size.x * 0.25, y + size.y * 0.15,
      x + size.x * 0.1, y + size.y * 0.15
    );
    triangle( // Top Middle Left
      x - size.x * 0.25, y - size.y * 0.25,
      x, y - size.y * 0.25,
      x, y - size.y * 0.4
    );
    triangle( // Top Middle Right
      x, y - size.y * 0.4,
      x, y - size.y * 0.25,
      x + size.x * 0.25, y - size.y * 0.25
    );
    rect(x - size.x * 0.425, y, size.x * 0.1, size.y * 0.25); // Left Gun
    rect(x + size.x * 0.325, y, size.x * 0.1, size.y * 0.25); // Left Gun
    
    rect(x - size.x * 0.05, y - size.y * 0.18, size.x * 0.1, size.y * 0.25); // Symbol Vertical
    rect(x - size.x * 0.175, y - size.y * 0.1, size.x * 0.35, size.y * 0.08); // Symbol Horizontal
  }
}

void drawStartScreen() {
  fill(255, 200, 0);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Space Defender 2", centrePos.x, centrePos.y - height * 0.4);
  textSize(20);
  text("Click on enemy ships to destroy them, dont let them reach the planet!\nFriendly ships reduce score if killed.", 
        centrePos.x, centrePos.y - height * 0.2);
  text("Ship speed increases over time, Missed shots reduce lives.\nKeep good accuracy to get a higher score.\n\nGood Luck!", 
        centrePos.x, centrePos.y - height * 0.05); 
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
  text("Time: " + formatMillis(millisPassed), centrePos.x, centrePos.y);
  text("Final Score: " + ceil(score - (score * ( 1 - (calcAccuracy() / 100.)))), centrePos.x, centrePos.y + height * 0.1); // Multiplies score by accuracy
  textAlign(LEFT);
  textSize(20);
  text("[r] New Round", width * 0.05, height * 0.8);
  text("[m] Title Screen", width * 0.05, height * 0.85);
  text("[q] Quit", width * 0.05, height * 0.9);
}

void drawInfoArea() {
  noStroke();
  fill(20);
  rect(0, 0, width, infoAreaY);
  textSize(24);
  fill(255);
  textAlign(CENTER, TOP);
  text("Space Defender 2", centrePos.x, infoAreaY / 5);
  text(formatMillis(millisPassed), centrePos.x, infoAreaY * 0.5);
  text("Score\n" + score, width * 0.05, infoAreaY / 4);
  text("Kills\n" + kills, width * 0.15, infoAreaY / 4);
  text("Accuracy\n " + calcAccuracy() + "%", width * 0.28, infoAreaY * 0.25);
  text("Lives", width * 0.85, infoAreaY / 4);
  drawLivesBar(new PVector(width * 0.85, infoAreaY * 0.6), new PVector(5, 5), 10, lives);
}

void drawLivesBar(PVector pos, PVector size, float iconDistance, int lives) {
  float barWidth = size.x + iconDistance * (lives + 1);
  float barCentre = barWidth * 0.5 - (size.x * 0.5);
  for (int i = 1; i <= lives; i++) { 
    fill(0, 255, 0);
    rect(pos.x - size.x * 0.5 - barCentre + iconDistance * i, pos.y, size.x, size.y);
  }
}

void drawCrosshair() {
  for(int i = 0; i < targetCount; i++) {
    int type = targetTypes[i];
    if (checkCollision(targetPositions[i], targetSizeValues[type], mousePos)) {
      if (type == 0) {
        xHairColor = color(255, 0, 0);
      } else {
        xHairColor = color(0, 255, 0); 
      }
      break;
    } else {
      xHairColor = color(255);
    }
  }

  stroke(xHairColor);
  strokeWeight(xHairSize.x);
  line(mousePos.x - xHairGap, mousePos.y, mousePos.x - xHairGap - xHairSize.y, mousePos.y); // Left
  line(mousePos.x + xHairGap, mousePos.y, mousePos.x + xHairGap + xHairSize.y, mousePos.y); // Right
  line(mousePos.x, mousePos.y - xHairGap, mousePos.x, mousePos.y - xHairGap - xHairSize.y); // Top  
  line(mousePos.x, mousePos.y + xHairGap, mousePos.x, mousePos.y + xHairGap + xHairSize.y); // Bottom  
  
  noFill();
  circle(mousePos.x, mousePos.y, xHairSize.y); // Ring
  stroke(250, 210, 0);
  strokeWeight(xHairSize.x * 2);
  point(mousePos.x, mousePos.y); // Centre
}

void drawShot(PVector startPos, PVector endPos, color col) {
  strokeWeight(3);
  stroke(col);
  line(startPos.x, startPos.y, endPos.x, endPos.y);
  fill(255, 85, 0);
  noStroke();
  circle(endPos.x, endPos.y, 15);
}

void drawFarShips() {
  for(int i = 0; i < farShipPositions.length; i++) {
    PVector pos = farShipPositions[i];
    PVector size;
    boolean drawShot = ((int)random(101) <= 1); // % chance for a ship to shot another when it is draw

    if (i <= farShipCount / 2 - 1) { //Left Ships
      size = farShipSizes[0];
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.45, pos.y, size.x * 0.2, size.y * 0.3); // Back Middle
      fill(80);
      rect(pos.x - size.x * 0.45, pos.y - size.y * 0.25, size.x * 0.15, size.y * 0.2); // Back Top
      rect(pos.x - size.x * 0.4, pos.y - size.y * 0.5, size.x * 0.05, size.y * 0.25); // Back Middle Top
      rect(pos.x - size.x * 0.35, pos.y - size.y * 0.5, size.x * 0.05, size.y * 0.1); // Right Top
      triangle( // Back Top
        pos.x - size.x * 0.45, 
        pos.y - size.y * 0.25,
        pos.x - size.x * 0.4, 
        pos.y - size.y * 0.5,
        pos.x - size.x * 0.4, 
        pos.y - size.y * 0.25
      );
      fill(80);
      triangle( // Back Top
        pos.x - size.x * 0.35, 
        pos.y - size.y * 0.25,
        pos.x - size.x * 0.35, 
        pos.y - size.y * 0.5,
        pos.x - size.x * 0.3, 
        pos.y - size.y * 0.25
      );
      triangle( // Top Half
        pos.x - size.x * 0.5, 
        pos.y - size.y * 0.2,
        pos.x - size.x * 0.4,
        pos.y + size.y * 0.1,
        pos.x + size.x * 0.5,
        pos.y + size.y * 0.1
       );
      triangle( // Bottom Half
        pos.x - size.x * 0.5, 
        pos.y + size.y * 0.5,
        pos.x - size.x * 0.4,
        pos.y + size.y * 0.2,
        pos.x + size.x * 0.5,
        pos.y + size.y * 0.2
       );
      fill(180, 0, 0);
      triangle( // 
        pos.x - size.x * 0.38, 
        pos.y - size.y * 0.05,
        pos.x - size.x * 0.38, 
        pos.y - size.y * 0.3,
        pos.x - size.x * 0.12, 
        pos.y - size.y * 0.05
      );
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.4, pos.y + size.y * 0.1, size.x * 0.8, size.y * 0.1); // Middle
      
      if (drawShot) {
        int index = (int)random(farShipCount * 0.5, farShipCount);
        PVector tPos = farShipPositions[index];
        PVector tSize = farShipSizes[0];
        PVector startPos = new PVector(random(pos.x - size.x * 0.5, pos.x + size.x * 0.5), random(pos.y - size.y * 0.5, pos.y + size.y * 0.5));
        PVector endPos = new PVector(random(tPos.x - tSize.x * 0.5, tPos.x + tSize.x * 0.5), random(tPos.y - tSize.y * 0.5, tPos.y + tSize.y * 0.5));
        drawShot(startPos, endPos, color(255, 100, 80));
      }
      
    } else { // Right Ships
      size = farShipSizes[1];
      fill(80);
      rect(pos.x - size.x * 0.4, pos.y - size.y * 0.3, size.x * 0.12, size.y * 0.4); // Front
      rect(pos.x - size.x * 0.3, pos.y - size.y * 0.34, size.x * 0.12, size.y * 0.65); // Front - 1
      rect(pos.x - size.x * 0.2, pos.y - size.y * 0.425, size.x * 0.55, size.y * 0.85); // Middle
      rect(pos.x + size.x * 0.2, pos.y - size.y * 0.5, size.x * 0.3, size.y * 0.2); // Top Back
      rect(pos.x + size.x * 0.2, pos.y + size.y * 0.3, size.x * 0.3, size.y * 0.2); // Bottom Back
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.5, pos.y - size.y * 0.25, size.x * 0.1, size.y * 0.05); // Top Antenna
      rect(pos.x - size.x * 0.48, pos.y - size.y * 0.05, size.x * 0.08, size.y * 0.05); // Middle Antenna
      rect(pos.x - size.x * 0.45, pos.y + size.y * 0.2, size.x * 0.15, size.y * 0.05); // Bottom Antenna
      rect(pos.x + size.x * 0.35, pos.y - size.y * 0.25, size.x * 0.1, size.y * 0.2); // Top Thruster
      rect(pos.x + size.x * 0.35, pos.y + size.y * 0.05, size.x * 0.1, size.y * 0.2); // Bottom Thruster
      fill(255, 195, 40);
      rect(pos.x - size.x * 0.15, pos.y - size.y * 0.3, size.x * 0.4, size.y * 0.2); // Top Middle
      rect(pos.x - size.x * 0.15, pos.y + size.y * 0.1, size.x * 0.4, size.y * 0.2); // Bottom Middle
      triangle( // Top Back
        pos.x + size.x * 0.35, 
        pos.y - size.y * 0.3,
        pos.x + size.x * 0.5, 
        pos.y - size.y * 0.3,  
        pos.x + size.x * 0.35, 
        pos.y - size.y * 0.1
      );
      triangle( // Bottom Back
        pos.x + size.x * 0.35, 
        pos.y + size.y * 0.3,
        pos.x + size.x * 0.5, 
        pos.y + size.y * 0.3,  
        pos.x + size.x * 0.35, 
        pos.y + size.y * 0.1
      );
      
      if (drawShot) {
        int index = (int)random(farShipCount * 0.5);
        PVector tPos = farShipPositions[index];
        PVector tSize = farShipSizes[1];
        PVector startPos = new PVector(random(pos.x - size.x * 0.5, pos.x + size.x * 0.5), random(pos.y - size.y * 0.5, pos.y + size.y * 0.5));
        PVector endPos = new PVector(random(tPos.x - tSize.x * 0.5, tPos.x + tSize.x * 0.5), random(tPos.y - tSize.y * 0.5, tPos.y + tSize.y * 0.5));
        drawShot(startPos, endPos, color(80, 255, 115));
      }
    } 
  }
}

void drawCloseShips() {
  // Left Ship
  fill(255);
  //rect(leftShipPos.x - leftShipSize.x * 0.5, leftShipPos.y - leftShipSize.y * 0.5, leftShipSize.x, leftShipSize.y);
  fill(80);
  rect(leftShipPos.x - leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.3, leftShipSize.x * 0.2, leftShipSize.y * 0.6); // Middle
  fill(180, 0, 0);
  rect(leftShipPos.x + leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.05, leftShipSize.x * 0.3, leftShipSize.y * 0.1); // Gun
  triangle( // Top Left
    leftShipPos.x - leftShipSize.x * 0.4, leftShipPos.y - leftShipSize.y * 0.3,
    leftShipPos.x, leftShipPos.y - leftShipSize.y * 0.5,
    leftShipPos.x, leftShipPos.y - leftShipSize.y * 0.3
  );
  triangle( // Top Right
    leftShipPos.x, leftShipPos.y - leftShipSize.y * 0.3,
    leftShipPos.x, leftShipPos.y - leftShipSize.y * 0.5,
    leftShipPos.x + leftShipPos.x * 0.6, leftShipPos.y - leftShipSize.y * 0.3
  );
  triangle( // Bottom Left
    leftShipPos.x - leftShipSize.x * 0.4, leftShipPos.y + leftShipSize.y * 0.3,
    leftShipPos.x, leftShipPos.y + leftShipSize.y * 0.5,
    leftShipPos.x, leftShipPos.y + leftShipSize.y * 0.3
  );
  triangle( // Bottom Right
    leftShipPos.x, leftShipPos.y + leftShipSize.y * 0.3,
    leftShipPos.x, leftShipPos.y + leftShipSize.y * 0.5,
    leftShipPos.x + leftShipPos.x * 0.6, leftShipPos.y + leftShipSize.y * 0.3
  );
  fill(80);
  triangle( // Top Middle Left
    leftShipPos.x - leftShipSize.x * 0.5, leftShipPos.y - leftShipSize.y * 0.1,
    leftShipPos.x - leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.3,
    leftShipPos.x - leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.1
  );
  triangle( // Bottom Middle Left
    leftShipPos.x - leftShipSize.x * 0.5, leftShipPos.y + leftShipSize.y * 0.1,
    leftShipPos.x - leftShipSize.x * 0.1, leftShipPos.y + leftShipSize.y * 0.3,
    leftShipPos.x - leftShipSize.x * 0.1, leftShipPos.y + leftShipSize.y * 0.1
  );
  triangle( // Top Middle Right
    leftShipPos.x + leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.15,
    leftShipPos.x + leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.3,
    leftShipPos.x + leftShipSize.x * 0.5, leftShipPos.y - leftShipSize.y * 0.15
  );
  triangle( // Bottom Middle Right
    leftShipPos.x + leftShipSize.x * 0.1, leftShipPos.y + leftShipSize.y * 0.15,
    leftShipPos.x + leftShipSize.x * 0.1, leftShipPos.y + leftShipSize.y * 0.3,
    leftShipPos.x + leftShipSize.x * 0.5, leftShipPos.y + leftShipSize.y * 0.15
  );

  
  stroke(255, 0, 0);
  strokeWeight(2);
  noStroke();
  
    
  // Right Ship
  rect(rightShipPos.x - rightShipSize.x * 0.5, rightShipPos.y - rightShipSize.y * 0.5, rightShipSize.x, rightShipSize.y);  
}

void drawStars() {
  for (int i = 0; i < starCount; i++)  {
    fill(starColors[i]);
    noStroke();
    circle(starPositions[i].x, starPositions[i].y, starSizes[i]);
  }
}

void drawMoon() {
  fill(220);
  circle(moonPos.x, moonPos.y, moonSize);
  for (int i = 0; i < craterCount; i++) {
    fill(170); 
    circle(craterPositions[i].x, craterPositions[i].y, craterSizes[i]);  
  }
}

void drawPlanet() {
  fill(150, 218, 240);
  ellipse(planetPos.x, planetPos.y, planetSize.x, planetSize.y);
  fill(12, 175, 0);  
  ellipse(planetPos.x, planetPos.y + height * 0.05, planetSize.x, planetSize.y);
}

void drawPlyShip() {
  fill(80);
  rect(plyShipPos.x - plyShipSize.x * 0.1, plyShipPos.y - plyShipSize.y * 0.5, plyShipSize.x * 0.2, plyShipSize.y * 0.25); // Middle Top
  rect(plyShipPos.x - plyShipSize.x * 0.2, plyShipPos.y - plyShipSize.y * 0.25, plyShipSize.x * 0.4, plyShipSize.y * 0.4); // Middle
  rect(plyShipPos.x - plyShipSize.x * 0.15, plyShipPos.y + plyShipSize.y * 0.15, plyShipSize.x * 0.3, plyShipSize.y * 0.1); // Middle Bottom
  fill(255, 195, 40);
  rect(plyShipPos.x - plyShipSize.x * 0.4, plyShipPos.y + plyShipSize.y * 0.2, plyShipSize.x * 0.15, plyShipSize.y * 0.25); // Left Thruster
  rect(plyShipPos.x + plyShipSize.x * 0.25, plyShipPos.y + plyShipSize.y * 0.2, plyShipSize.x * 0.15, plyShipSize.y * 0.25); // Right Thruster
  fill(80);
  rect(plyShipPos.x - plyShipSize.x * 0.4, plyShipPos.y - plyShipSize.y * 0.3, plyShipSize.x * 0.1, plyShipSize.y * 0.3); // Left Gun
  rect(plyShipPos.x + plyShipSize.x * 0.3, plyShipPos.y - plyShipSize.y * 0.3, plyShipSize.x * 0.1, plyShipSize.y * 0.3); // Right Gun
  fill(255, 195, 40);
  triangle( // Top Left
    plyShipPos.x - plyShipSize.x * 0.2, plyShipPos.y - plyShipSize.y * 0.25,
    plyShipPos.x - plyShipSize.x * 0.1, plyShipPos.y - plyShipSize.y * 0.5,
    plyShipPos.x - plyShipSize.x * 0.1, plyShipPos.y - plyShipSize.y * 0.25
  );
  triangle( // Top Right
    plyShipPos.x + plyShipSize.x * 0.1, plyShipPos.y - plyShipSize.y * 0.25,
    plyShipPos.x + plyShipSize.x * 0.1, plyShipPos.y - plyShipSize.y * 0.5,
    plyShipPos.x + plyShipSize.x * 0.2, plyShipPos.y - plyShipSize.y * 0.25
  );
  
  triangle( // Middle Left
    plyShipPos.x - plyShipSize.x * 0.5, plyShipPos.y + plyShipSize.y * 0.15,
    plyShipPos.x - plyShipSize.x * 0.2, plyShipPos.y - plyShipSize.y * 0.25,
    plyShipPos.x - plyShipSize.x * 0.2, plyShipPos.y + plyShipSize.y * 0.15
  );
  triangle( // Middle Right
    plyShipPos.x + plyShipSize.x * 0.2, plyShipPos.y + plyShipSize.y * 0.15,    
    plyShipPos.x + plyShipSize.x * 0.2, plyShipPos.y - plyShipSize.y * 0.25,
    plyShipPos.x + plyShipSize.x * 0.5, plyShipPos.y + plyShipSize.y * 0.15
  );
  fill(80);
  triangle( // Bottom Left
    plyShipPos.x - plyShipSize.x * 0.5, plyShipPos.y + plyShipSize.y * 0.15,
    plyShipPos.x - plyShipSize.x * 0.2, plyShipPos.y + plyShipSize.y * 0.15,
    plyShipPos.x - plyShipSize.x * 0.5, plyShipPos.y + plyShipSize.y * 0.5

  );
  triangle( // Bottom Right
    plyShipPos.x + plyShipSize.x * 0.2, plyShipPos.y + plyShipSize.y * 0.15, 
    plyShipPos.x + plyShipSize.x * 0.5, plyShipPos.y + plyShipSize.y * 0.15,
    plyShipPos.x + plyShipSize.x * 0.5, plyShipPos.y + plyShipSize.y * 0.5
  );
}

void drawSpaceStation() {
  fill(80);
  rect(stationPos.x - stationSize.x * 0.5, stationPos.y - stationSize.y * 0.2, stationSize.x * 0.3, stationSize.y * 0.6); // Left
  rect(stationPos.x + stationSize.x * 0.3, stationPos.y - stationSize.y * 0.5, stationSize.x * 0.2, stationSize.y); // Right
  rect(stationPos.x - stationSize.x * 0.2, stationPos.y, stationSize.x * 0.5, stationSize.y * 0.25); // Middle
  fill(255, 195, 40);
  rect(stationPos.x + stationSize.x * 0.35, stationPos.y - stationSize.y * 0.4, stationSize.x * 0.1, stationSize.y * 0.8); // Right Light
  fill(80);
  rect(stationPos.x - stationSize.x * 0.45, stationPos.y - stationSize.y * 0.5, stationSize.x * 0.05, stationSize.y * 0.4); // Left antenna
  rect(stationPos.x - stationSize.x * 0.35, stationPos.y - stationSize.y * 0.3, stationSize.x * 0.05, stationSize.y * 0.15); // Right antenna
  
  if (millis() > lastLightTime + 1000){
    lightOn = !lightOn;
    lastLightTime = millis();
  } 
  
  if (lightOn) {
    fill(0, 255, 0);
  } else {
    fill(100); 
  }
  
  rect(stationPos.x - stationSize.x * 0.45, stationPos.y - stationSize.y * 0.5, stationSize.x * 0.05, stationSize.y * 0.1); // Left antenna Light

  for (int i = 0; i < 3; i++) { // Left Lights
    float posY = stationPos.y + stationSize.y * (0.25 - i * 0.2);
    for (int k = 0; k < 3; k++) {
      float posX = stationPos.x - stationSize.x * (0.275 + k * 0.1);
      fill(255, 195, 40);
      rect(posX, posY, stationSize.x * 0.05, stationSize.y * 0.1);
    }
  }
}
