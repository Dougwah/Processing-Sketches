// Make background ships smaller and add an array to spawn multiple
// Add 2 more background ships on either side that shoot at targets when they randomly dissapear
// Make player ship that faces upwards and shoots 2 lasers that converge on the click coords
// Ships spawn with a randomised life time and die if reached before making to the planet
// Remake ships as they only face downwards now
// Separate draw background objects into different funcs
// Make menu background

// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxLives = 6;
int targetCount = 5;

// Station
PVector stationSize = new PVector(70, 40);
PVector stationPos;
boolean lightOn = false;
int lastLightTime = millis();

// Crosshair
PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
color xHairColor = color(255, 255, 255);

// Targets
int[] targetKillPointValues = {4, -1};
int[] targetExpirePointValues = {-2, 2}; // Point awards when targets die randomly or when touching the planet
int[] targetDamageValues = {1, -1}; // Friendlies add lives when they make it to the planet
PVector[] targetSizeValues = {
  new PVector(70, 30),
  new PVector(70, 30)
};

// ===== BACKGROUND OBJECT SETTINGS =====

// Far Ships
int farShipCount = 8;
PVector[] farShipSizes = {
  new PVector(100, 40), // 1 : 2.5 aspect ratio
  new PVector(100, 40)
};
PVector[][] farShipBounds = new PVector[farShipCount][farShipCount];

//PVector lShipSize = new PVector(300, 120); // 1 : 2.5 aspect ratio
//PVector lShipPos;
//PVector rShipSize = new PVector(300, 120);
//PVector rShipPos;

// Close Ships

// Stars
int starCount = 150;
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

// ===== PROCESSING FUNCTIONS =====

void setup() {
  noCursor();
  size(800, 600);
  centrePos = new PVector(width * 0.5, height * 0.5 + infoAreaY * 0.5);
  stationPos = new PVector(width * 0.9, height * 0.75);
  moonPos = new PVector(width * 0.1, height * 0.7);
  
  farShipBounds[0] = new PVector[] { // Ships on the left
    new PVector(farShipSizes[0].x * 0.5, infoAreaY + farShipSizes[0].y * 0.5), // Minimum Coords
    new PVector(width * 0.5 - farShipSizes[0].x, height * 0.4 - farShipSizes[0].y * 0.5) // Maximum Coords
  };
  farShipBounds[1] = new PVector[] { // Ships on the right
    new PVector(width * 0.5 + farShipSizes[1].x * 0.5, infoAreaY + farShipSizes[1].y * 0.5),
    new PVector(width - farShipSizes[1].x * 0.5, height * 0.4 - farShipSizes[1].y * 0.5)
  };
  
  //lShipPos = new PVector(180, 200);
  //rShipPos = new PVector(width - 180, 180);
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
     
    drawBackgroundObjects();
    drawFarShips();
    drawCrosshair();
    drawInfoArea();
    
    millisPassed += millis() - lastMilli;
    lastMilli = millis();
  }
}

void mousePressed() {
 if (gameState == 1) {
    shotsTaken++;
    stroke(250, 210, 0);
    strokeWeight(3);
    line(centrePos.x + stationSize.x * 0.025 + 3, centrePos.y - stationSize.y * 0.15 + 3, mousePos.x, mousePos.y);
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
  generateFarShips();
  generateMoonCraters();
  generateStars();
  gameState = 1;
}

void endRound() {
  gameState = 2;
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    starPositions[i] = new PVector((int)random(width), (int)random(infoAreaY, height));
    starColors[i] = starColorList[floor(random(starColorList.length))];
    starSizes[i] = random(1, 3);
  }
}

void generateFarShips() {
  int lastY = (int)(farShipBounds[0][0].y + random(0, 60));

  for(int i = 0; i < farShipCount / 2; i++) {
    farShipPositions[i] = new PVector((int)random(farShipBounds[0][0].x, farShipBounds[0][1].x), lastY);
    lastY += farShipSizes[0].y + (int)random(0, 20);
  }
  
  lastY = (int)(farShipBounds[1][0].y + random(0, 60));
  for(int i = farShipCount / 2; i < farShipCount; i++) {
    farShipPositions[i] = new PVector((int)random(farShipBounds[1][0].x, farShipBounds[1][1].x), lastY);
    lastY += farShipSizes[1].y + (int)random(0, 20); 
  }
  
  
  
  //for (int i = 0; i < farShipCount; i++) {
  //  if(i <= farShipCount * 0.5 - 1) {
  //    type = 0;
  //  } else {
  //    type = 1;
  //    //lastY = (int)farShipBounds[1][0].y;
  //  }
    
  //  lastY += farShipSizes[type].y + (int)random(0, 20);
  //  farShipPositions[i] = new PVector((int)random(farShipBounds[type][0].x, farShipBounds[type][1].x), lastY);
     
  //   //for(int k = 0; k < i; k++) { // Check all previous positions for overlapping
  //   //  float yDistance = Math.abs(farShipPositions[k].y - farShipPositions[i].y);
  //   //  float xDistance = Math.abs(farShipPositions[k].x - farShipPositions[i].x);
  //   //  if (xDistance <= farShipSizes[type].x && yDistance <= farShipSizes[type].y) {
  //   //    farShipPositions[i].y += yDistance + farShipSizes[type].y;
  //   //  }
  //   //}
  //}
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

// Circular collision
boolean checkCollision(PVector pos1, int rad1, PVector pos2, int rad2) {
  if(PVector.sub(pos1, pos2).mag() < rad1 + rad2) {
    return true;
  }
  
  return false;
}

// Rectangular collision
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
  
}

void killTarget(int index) {
  
}

// ===== DRAW FUNCTIONS =====

void target(float x, float y, int typeOfTarget) {
  PVector size = targetSizeValues[typeOfTarget];
  noStroke();
  if (typeOfTarget == 0) { // Enemy
    fill(150, 150, 150);
    triangle(
      x - size.x * 0.5,
      y - size.y * 0.2,    
      x,
      y - size.y * 0.5,         
      x + size.x * 0.5,
      y - size.y * 0.2
    );
    triangle(
      x + size.x * 0.5,
      y + size.y * 0.2,  
      x,
      y + size.y * 0.5,        
      x - size.x * 0.5,
      y + size.y * 0.2
    );
    rect(x - size.x * 0.15, y - size.y * 0.25, size.x * 0.3, size.y * 0.5);
    fill(200, 200, 200);
    circle(x, y, size.y * 0.5);
    fill(255, 0, 0);
    rect(x - size.x * 0.05, y - size.y * 0.1, size.x * 0.1, size.y * 0.2);
  } else { // Friendly
    fill(150, 150, 150);
    ellipse(x, y, size.x, size.y);
    fill(200, 200, 200);
    rect(x - size.x * 0.5, y - size.y * 0.2, size.x, size.y * 0.4);
    fill(0, 255, 0);
    rect(x - size.x * 0.4, y - size.y * 0.1, size.x * 0.2, size.y * 0.2);    
    rect(x - size.x * 0.1, y - size.y * 0.1, size.x * 0.2, size.y * 0.2);
    rect(x + size.x * 0.2, y - size.y * 0.1, size.x * 0.2, size.y * 0.2);
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
  fill(#626262);
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
  drawLivesBar(new PVector(width * 0.85, infoAreaY * 0.6), new PVector(20, 20), 30, lives);
}

void drawCrosshair() {
  xHairColor = color(255, 255, 255); 

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

    if(i <= farShipCount / 2 - 1) { //Left Ships
      size = farShipSizes[0];
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.45, pos.y, size.x * 0.2, size.y * 0.3); // Back
      fill(230, 255, 255);
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
      fill(140, 130, 130);
      triangle(
        pos.x - size.x * 0.38, 
        pos.y - size.y * 0.05,
        pos.x - size.x * 0.38, 
        pos.y - size.y * 0.3,
        pos.x - size.x * 0.12, 
        pos.y - size.y * 0.05
      );
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.4, pos.y + size.y * 0.1, size.x * 0.8, size.y * 0.1); // Middle
      
      if(drawShot) {
        int index = (int)random(farShipCount * 0.5, farShipCount);
        PVector tPos = farShipPositions[index];
        PVector tSize = farShipSizes[0];
        PVector startPos = new PVector(random(pos.x - size.x * 0.5, pos.x + size.x * 0.5), random(pos.y - size.y * 0.5, pos.y + size.y * 0.5));
        PVector endPos = new PVector(random(tPos.x - tSize.x * 0.5, tPos.x + tSize.x * 0.5), random(tPos.y - tSize.y * 0.5, tPos.y + tSize.y * 0.5));
        drawShot(startPos, endPos, color(255, 100, 80));
      }
      
    } else { // Right Ships
      size = farShipSizes[1];
      
      fill(230, 255, 255);
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
      rect(pos.x - size.x * 0.15, pos.y - size.y * 0.3, size.x * 0.4, size.y * 0.2); // Top Middle
      rect(pos.x - size.x * 0.15, pos.y + size.y * 0.1, size.x * 0.4, size.y * 0.2); // Bottom Middle
      fill(230, 255, 255);
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
      
      if(drawShot) {
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

void drawBackgroundObjects() {
  // Stars
  for (int i = 0; i < starCount; i++)  {
    fill(starColors[i]);
    noStroke();
    circle(starPositions[i].x, starPositions[i].y, starSizes[i]);
  }
  
  // Planet
  fill(160, 10, 185);
  ellipse(width * 0.5, height * 1.1, width * 2.2, height * 0.5);
  
  // Player Ship
  fill(255, 195, 40);
  square(constrain(mouseX - 10, 0, width - 20), height * 0.8, 20);
  
  // Space Station
  fill(color(150, 150, 150));
  rect(stationPos.x - stationSize.x * 0.5, stationPos.y - stationSize.y * 0.2, stationSize.x * 0.3, stationSize.y * 0.6); // Left
  rect(stationPos.x + stationSize.x * 0.3, stationPos.y - stationSize.y * 0.5, stationSize.x * 0.2, stationSize.y); // Right
  fill(255);
  rect(stationPos.x + stationSize.x * 0.35, stationPos.y - stationSize.y * 0.4, stationSize.x * 0.1, stationSize.y * 0.8); // Right Light
  fill(color(150, 150, 150));
  rect(stationPos.x, stationPos.y - stationSize.y * 0.2, stationSize.x * 0.1, stationSize.y * 0.2); // Middle Top
  fill(250, 210, 0);
  rect(stationPos.x + stationSize.x * 0.025, stationPos.y - stationSize.y * 0.15, stationSize.x * 0.05, stationSize.y * 0.1); // Laser Origin
  fill(color(150, 150, 150));
  rect(stationPos.x - stationSize.x * 0.45, stationPos.y - stationSize.y * 0.5, stationSize.x * 0.05, stationSize.y * 0.4); // Left antenna
  
  if (millis() > lastLightTime + 1000){
    lightOn = !lightOn;
    lastLightTime = millis();
  } 
  
  if (lightOn) {
    fill(0, 255, 0);
  } else {
    fill(100, 100, 100); 
  }
  
  rect(stationPos.x - stationSize.x * 0.45, stationPos.y - stationSize.y * 0.5, stationSize.x * 0.05, stationSize.y * 0.1); // Left antenna Light
  fill(color(150, 150, 150));
  rect(stationPos.x - stationSize.x * 0.35, stationPos.y - stationSize.y * 0.3, stationSize.x * 0.05, stationSize.y * 0.15); // Right antenna
  rect(stationPos.x - stationSize.x * 0.2, stationPos.y, stationSize.x * 0.5, stationSize.y * 0.25); // Middle Bottom
  
  for (int i = 0; i < 3; i++) { // Left Lights
    float posY = stationPos.y + stationSize.y * (0.25 - i * 0.2);
    for (int k = 0; k < 3; k++) {
      float posX = stationPos.x - stationSize.x * (0.275 + k * 0.1);
      fill(255);
      rect(posX, posY, stationSize.x * 0.05, stationSize.y * 0.1);
    }
  }

  // Moon
  fill(220, 220, 220);
  circle(moonPos.x, moonPos.y, moonSize);
  for (int i = 0; i < craterCount; i++) {
    fill(170, 170, 170); 
    circle(craterPositions[i].x, craterPositions[i].y, craterSizes[i]);  
  }
}

void drawLivesBar(PVector pos, PVector size, float iconDistance, int lives) {
  float barWidth = size.x + iconDistance * (lives + 1);
  float barCentre = barWidth * 0.5 - (size.x * 0.5);
  for (int i = 1; i <= lives; i++) { 
    fill(0, 255, 0);
    rect(pos.x - size.x * 0.5 - barCentre + iconDistance * i, pos.y, size.x, size.y);
  }
}
