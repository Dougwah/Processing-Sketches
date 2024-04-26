// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxLives = 5;
int maxTargets = 5;

// Station
PVector stationSize = new PVector(140, 80);
color stationOriginalColor = color(150, 150, 150);
boolean lightOn = false;
int lastLightTime = millis();

// Crosshair
PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
color xHairColor = color(255, 255, 255);

// ===== BACKGROUND OBJECT SETTINGS =====

// Ships
PVector lShipSize = new PVector(300, 120); // 1 : 2.5 aspect ratio
PVector lShipPos;
PVector rShipSize = new PVector(300, 120);
PVector rShipPos;

// Stars
int starCount = 150;
PVector[] starPositions = new PVector[starCount];
float[] starSizes = new float[starCount];
color[] starColors = new color[starCount];
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
int moonSize = 200;
int craterCount = 15;
int craterMaxSize = 40;
int craterMinSize = 10;
PVector moonPos;
PVector[] craterPositions = new PVector[craterCount];
float[] craterSizes = new float[craterCount];

// Menu Background

// ===== CURRENT ROUND VALUES =====

// Game
int gameState = 0; // 0 == start screen, 1 = game screen, 2 = end screen
int millisPassed;
int lastMilli;
PVector centrePos;
color stationColor;

// Player
int score;
int kills;
int lives;
float shotsTaken;
float shotsHit;
PVector mousePos = new PVector(); // Make instance here instead of the draw function

// Targets
int[] targetTypes = new int[maxTargets];
PVector[] targetPositions = new PVector[maxTargets];
PVector[] targetVelocities = new PVector[maxTargets];
boolean[] targetStates = new boolean[maxTargets];

// ===== PROCESSING FUNCTIONS =====

void setup() {
  noCursor();
  size(800, 600);
  centrePos = new PVector(width * 0.5, height * 0.5 + infoAreaY * 0.5);
  lShipPos = new PVector(180, 200);
  rShipPos = new PVector(width - 180, 180);
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
    drawCrosshair();
    drawInfoArea();
    
    millisPassed += millis() - lastMilli;
    lastMilli = millis();
  }
}

void mousePressed() {
  
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
  stationColor = stationOriginalColor;
  generateMoon();
  generateStars();
  gameState = 1;
}

void endRound() {
  gameState = 2;
}


void runTargets() {
  
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    starPositions[i] = new PVector(random(width), random(infoAreaY, height));
    starColors[i] = starColors[floor(random(starColors.length))];
    starSizes[i] = random(1, 3);
  }
}

void generateMoon() {
  moonPos = new PVector(width * 0.85, height * 0.75);
  for (int i = 0; i < craterCount; i++) {
    float craterSize = random(craterMinSize, craterMaxSize);
    float magnitude = moonSize / random(2, 4) - craterSize / 2;
    PVector relativePos = new PVector(random(-1, 1), random(-1, 1)).setMag(magnitude);
    craterPositions[i] = PVector.add(moonPos, relativePos);
    craterSizes[i] = craterSize;
  }
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
  return nf(seconds / 60, 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
}

int calcAccuracy() {
  if (shotsTaken == 0) {
    return 0;  
  }
  return round(shotsHit / shotsTaken * 100);
}

// ===== DRAW FUNCTIONS =====

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

void drawBackgroundObjects() {
  // Stars
  for (int i = 0; i < starCount; i++)  {
    fill(starColors[i]);
    noStroke();
    circle(starPositions[i].x, starPositions[i].y, starSizes[i]);
  }
  
  // Space Station
  stationColor = lerpColor(stationColor, stationOriginalColor, 0.1);
  
  fill(stationColor);
  rect(centrePos.x - stationSize.x * 0.5, centrePos.y - stationSize.y * 0.2, stationSize.x * 0.3, stationSize.y * 0.6); // Left
  rect(centrePos.x + stationSize.x * 0.3, centrePos.y - stationSize.y * 0.5, stationSize.x * 0.2, stationSize.y); // Right
  fill(255);
  rect(centrePos.x + stationSize.x * 0.35, centrePos.y - stationSize.y * 0.4, stationSize.x * 0.1, stationSize.y * 0.8); // Right Light
  fill(stationColor);
  rect(centrePos.x, centrePos.y - stationSize.y * 0.2, stationSize.x * 0.1, stationSize.y * 0.2); // Middle Top
  fill(250, 210, 0);
  rect(centrePos.x + stationSize.x * 0.025, centrePos.y - stationSize.y * 0.15, stationSize.x * 0.05, stationSize.y * 0.1); // Laser Origin
  fill(stationColor);
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
  fill(stationColor);
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

  // Moon
  fill(220, 220, 220);
  circle(moonPos.x, moonPos.y, 200);
  for (int i = 0; i < craterCount; i++) {
    fill(170, 170, 170); 
    circle(craterPositions[i].x, craterPositions[i].y, craterSizes[i]);  
  }
  
  // Left Ship
  fill(140, 130, 130);
  rect(lShipPos.x - lShipSize.x * 0.45, lShipPos.y, lShipSize.x * 0.2, lShipSize.y * 0.3); // Back
  fill(230, 255, 255);
  rect(lShipPos.x - lShipSize.x * 0.45, lShipPos.y - lShipSize.y * 0.25, lShipSize.x * 0.15, lShipSize.y * 0.2); // Back Top
  rect(lShipPos.x - lShipSize.x * 0.4, lShipPos.y - lShipSize.y * 0.5, lShipSize.x * 0.05, lShipSize.y * 0.25); // Back Middle Top
  rect(lShipPos.x - lShipSize.x * 0.35, lShipPos.y - lShipSize.y * 0.5, lShipSize.x * 0.05, lShipSize.y * 0.1); // Right Top
  triangle( // Back Top
    lShipPos.x - lShipSize.x * 0.45, 
    lShipPos.y - lShipSize.y * 0.25,
    lShipPos.x - lShipSize.x * 0.4, 
    lShipPos.y - lShipSize.y * 0.5,
    lShipPos.x - lShipSize.x * 0.4, 
    lShipPos.y - lShipSize.y * 0.25
  );
  triangle( // Back Top
    lShipPos.x - lShipSize.x * 0.35, 
    lShipPos.y - lShipSize.y * 0.25,
    lShipPos.x - lShipSize.x * 0.35, 
    lShipPos.y - lShipSize.y * 0.5,
    lShipPos.x - lShipSize.x * 0.3, 
    lShipPos.y - lShipSize.y * 0.25
  );
  triangle( // Top Half
    lShipPos.x - lShipSize.x * 0.5, 
    lShipPos.y - lShipSize.y * 0.2,
    lShipPos.x - lShipSize.x * 0.4,
    lShipPos.y + lShipSize.y * 0.1,
    lShipPos.x + lShipSize.x * 0.5,
    lShipPos.y + lShipSize.y * 0.1
   );
  triangle( // Bottom Half
    lShipPos.x - lShipSize.x * 0.5, 
    lShipPos.y + lShipSize.y * 0.5,
    lShipPos.x - lShipSize.x * 0.4,
    lShipPos.y + lShipSize.y * 0.2,
    lShipPos.x + lShipSize.x * 0.5,
    lShipPos.y + lShipSize.y * 0.2
   );
  fill(140, 130, 130);
  triangle(
    lShipPos.x - lShipSize.x * 0.38, 
    lShipPos.y - lShipSize.y * 0.05,
    lShipPos.x - lShipSize.x * 0.38, 
    lShipPos.y - lShipSize.y * 0.3,
    lShipPos.x - lShipSize.x * 0.12, 
    lShipPos.y - lShipSize.y * 0.05
  );

  fill(140, 130, 130);
  rect(lShipPos.x - lShipSize.x * 0.4, lShipPos.y + lShipSize.y * 0.1, lShipSize.x * 0.8, lShipSize.y * 0.1); // Middle

  // Right Ship
  fill(230, 255, 255);
  rect(rShipPos.x - rShipSize.x * 0.4, rShipPos.y - rShipSize.y * 0.3, rShipSize.x * 0.12, rShipSize.y * 0.4); // Front
  rect(rShipPos.x - rShipSize.x * 0.3, rShipPos.y - rShipSize.y * 0.34, rShipSize.x * 0.12, rShipSize.y * 0.65); // Front - 1
  rect(rShipPos.x - rShipSize.x * 0.2, rShipPos.y - rShipSize.y * 0.425, rShipSize.x * 0.55, rShipSize.y * 0.85); // Middle
  rect(rShipPos.x + rShipSize.x * 0.2, rShipPos.y - rShipSize.y * 0.5, rShipSize.x * 0.3, rShipSize.y * 0.2); // Top Back
  rect(rShipPos.x + rShipSize.x * 0.2, rShipPos.y + rShipSize.y * 0.3, rShipSize.x * 0.3, rShipSize.y * 0.2); // Bottom Back
  fill(140, 130, 130);
  rect(rShipPos.x - rShipSize.x * 0.5, rShipPos.y - rShipSize.y * 0.25, rShipSize.x * 0.1, rShipSize.y * 0.05); // Top Antenna
  rect(rShipPos.x - rShipSize.x * 0.48, rShipPos.y - rShipSize.y * 0.05, rShipSize.x * 0.08, rShipSize.y * 0.05); // Middle Antenna
  rect(rShipPos.x - rShipSize.x * 0.45, rShipPos.y + rShipSize.y * 0.2, rShipSize.x * 0.15, rShipSize.y * 0.05); // Bottom Antenna
  rect(rShipPos.x + rShipSize.x * 0.35, rShipPos.y - rShipSize.y * 0.25, rShipSize.x * 0.1, rShipSize.y * 0.2); // Top Thruster
  rect(rShipPos.x + rShipSize.x * 0.35, rShipPos.y + rShipSize.y * 0.05, rShipSize.x * 0.1, rShipSize.y * 0.2); // Bottom Thruster
  rect(rShipPos.x - rShipSize.x * 0.15, rShipPos.y - rShipSize.y * 0.3, rShipSize.x * 0.4, rShipSize.y * 0.2); // Top Middle
  rect(rShipPos.x - rShipSize.x * 0.15, rShipPos.y + rShipSize.y * 0.1, rShipSize.x * 0.4, rShipSize.y * 0.2); // Bottom Middle
  fill(230, 255, 255);
  triangle( // Top Back
    rShipPos.x + rShipSize.x * 0.35, 
    rShipPos.y - rShipSize.y * 0.3,
    rShipPos.x + rShipSize.x * 0.5, 
    rShipPos.y - rShipSize.y * 0.3,  
    rShipPos.x + rShipSize.x * 0.35, 
    rShipPos.y - rShipSize.y * 0.1
  );
  triangle( // Bottom Back
    rShipPos.x + rShipSize.x * 0.35, 
    rShipPos.y + rShipSize.y * 0.3,
    rShipPos.x + rShipSize.x * 0.5, 
    rShipPos.y + rShipSize.y * 0.3,  
    rShipPos.x + rShipSize.x * 0.35, 
    rShipPos.y + rShipSize.y * 0.1
  );
  
  // Laser effects
  if ((int)random(101) <= 5) {
    float lShipLinePosX = random(lShipPos.x - lShipSize.x * 0.5, lShipPos.x + lShipSize.x * 0.5);
    float lShipLinePosY = random(lShipPos.y, lShipPos.y + lShipSize.y * 0.5);
    float rShipLinePosX = random(rShipPos.x - rShipSize.x * 0.5, rShipPos.x + rShipSize.x * 0.5); 
    float rShipLinePosY =random(rShipPos.y - rShipSize.y * 0.5, rShipPos.y + rShipSize.y * 0.5);
    
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

void drawLivesBar(PVector pos, PVector size, float iconDistance, int lives) {
  float barWidth = size.x + iconDistance * (lives + 1);
  float barCentre = barWidth * 0.5 - (size.x * 0.5);
  for (int i = 1; i <= lives; i++) { 
    fill(0, 255, 0);
    rect(pos.x - size.x / 2 - barCentre + iconDistance * i, pos.y, size.x, size.y);
  }
}

void target(float x, float y, int typeOfTarget) {
  
}
