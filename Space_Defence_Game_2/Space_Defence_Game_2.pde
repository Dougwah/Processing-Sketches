// ===== GAME SETTINGS ===== 

// General
int infoAreaY = 80;
int maxLives = 8;
int targetCount = 5; // Change this for more enemies
int menuSquareCountX = 80;
int menuSquareCountY = 60;

// Crosshair
PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
color xHairColor = color(255);

// Targets
int[] targetKillScoreValues = {4, -1};
int[] targetDamageValues = {-1, 1}; // Friendlies add lives when they make it to the planet
int targetMinLifeTime = 1;
int targetMaxLifeTime = 6;
float targetMinSpeed = 1;
float targetMaxSpeed = 2.5;
PVector[] targetSizeValues = {
  new PVector(40, 60),
  new PVector(50, 70)
};
int friendlySpawnChance = 25; // Percentage chance for a friendly to spawn in place of an enemy, values lower than 0.1 evaluate to 0;
boolean enableEnemyLifeTimer = true;

// ===== BACKGROUND OBJECT SETTINGS =====

// Colors
color friendlyColor = color(255, 195, 40); // Default colors if not using random color function
color friendlyLaserColor = color(80, 255, 115);
color enemyColor = color(180, 0, 0);
color enemyLaserColor = color(255, 100, 80);
color plyColor = color(255, 195, 40);
color plyLaserColor = color(250, 210, 0);

// Far Background Ships
int farShipCount = 20; // Will attempt to spawn this many ships without overlaps, very rarely spawns more than 16
float farShipShootChance = 0.5; // Percentage chance for each ship to shoot another when it is drawn, values lower than 0.1 evaluate to 0;
PVector[] farShipSizes = {
  new PVector(100, 40), // 1 : 2.5 aspect ratio
  new PVector(100, 40)
};
PVector[][] farShipBounds = new PVector[2][2];

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

// PlayerShip
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
int menuSquareSize;

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
float currentTargetMinSpeed;

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
int generatedFarShipCount = 0;

// Close Background Ships
PVector leftShipPos;
PVector leftShipLaserPos;
PVector rightShipPos;
PVector rightShipLaserPos;

// ===== PROCESSING FUNCTIONS =====

void setup() {
  size(800, 600);
  //generateColors(); // Made a cool effect but was generating ugly colors that made the game harder
  menuSquareSize = width / menuSquareCountX;
  centrePos = new PVector(width * 0.5, height * 0.5 + infoAreaY * 0.5);
  stationPos = new PVector(width * 0.65, height * 0.6);
  moonPos = new PVector(width * 0.5, height * 0.6);
  leftShipPos = new PVector(width * 0.1, height * 0.65);
  leftShipLaserPos = new PVector(leftShipPos.x + leftShipSize.x * 0.4, leftShipPos.y);
  rightShipPos = new PVector(width * 0.9, height * 0.65);
  rightShipLaserPos = new PVector(rightShipPos.x - rightShipSize.x * 0.3, rightShipPos.y);
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
    // Ship doesnt appear centered to the mouse unless 0.5 is added to the x coord
    plyShipPos.x = constrain(mouseX + 0.5, plyShipSize.x * 0.5, width - plyShipSize.x * 0.5);
    
    currentTargetMinSpeed = min(currentTargetMinSpeed + 0.0001, targetMaxSpeed);
   
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
    drawShot(new PVector(plyShipPos.x - plyShipSize.x * 0.35, plyShipPos.y - plyShipSize.y * 0.3), mousePos, plyLaserColor);
    drawShot(new PVector(plyShipPos.x + plyShipSize.x * 0.35, plyShipPos.y - plyShipSize.y * 0.3), mousePos, plyLaserColor);
    boolean targetHit = false;
    for(int i = 0; i < targetCount; i++) {
      int type = targetTypes[i];
      if (checkPointCollision(targetPositions[i], targetSizeValues[type], mousePos)) {
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
  noCursor();
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
  currentTargetMinSpeed = targetMinSpeed;
  for(int i = 0; i < targetCount; i++) {
    despawnTarget(i);
  }
  gameState = 1;
}

void endRound() {
  cursor();
  gameState = 2;
}

void updateLives(int _lives) {
  lives = min(maxLives, lives + _lives);
  if (lives <= 0) {
    endRound();  
  }
}

void updateScore(int _score) {
  score += _score;
}

void generateColors() {
  friendlyColor = color((int)random(60), (int)random(256), (int)random(256));
  enemyColor = color((int)random(256), (int)random(60), (int)random(256));
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    starPositions[i] = new PVector((int)random(width), (int)random(infoAreaY, height)); // Converting to int to remove the decimal makes the stars look nicer
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
  int attempts = 0;
  int validPositions = 0;

  for(int i = 0; i < farShipCount && attempts < 1000; i++) { // Stops loop if a new spot cant be found after 1000 attempts
    boolean isValid = true;
    int shipType = validPositions % 2;
    
    PVector pos = new PVector(
      (int)random(farShipBounds[shipType][0].x, farShipBounds[shipType][1].x), 
      (int)random(farShipBounds[shipType][0].y, farShipBounds[shipType][1].y)
    );

    for(int k = 0; k < validPositions && isValid; k++) { // Check if the generated position overlaps with any previous positions
      PVector pos2 = farShipPositions[k];
      if(checkRectCollision(pos, farShipSizes[shipType], pos2, farShipSizes[shipType])) {
        isValid = false;
      }
    }
    
    if(isValid) { // Add the position
      farShipPositions[i] = pos;
      validPositions++;
      attempts = 0;
    } else { // Repeat the loop to find a new position
      i--;
      attempts++;
    }
  }
  
  generatedFarShipCount = validPositions;
}

// Ellipse overlap collision, for ships reaching the planet
boolean checkEllipseCollision(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  if (abs(pos1.x - pos2.x) < abs((size1.x + size2.x) / 2) && abs(pos1.y - pos2.y) < abs((size1.y + size2.y) / 2)) {
    return true;
  }
  return false;
}

// Rectangular overlap collision, for generating background ships
boolean checkRectCollision(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  if (pos1.x + size1.x * 0.5 < pos2.x - size2.x * 0.5 || pos1.x - size1.x * 0.5 > pos2.x + size2.x * 0.5) {
    return false; 
  }
  if (pos1.y + size1.y * 0.5 < pos2.y - size2.y * 0.5 || pos1.y - size1.y * 0.5 > pos2.y + size2.y * 0.5) {
    return false; 
  }
  return true;
}

// Rectangular overlap with point, for shooting targets
boolean checkPointCollision(PVector pos, PVector size, PVector point) {
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

String formatTime(int millis) {
  int seconds = millis / 1000;
  return nf(seconds / 60, 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
}

String formatSeconds(int millis) {
  int seconds = millis / 1000;
  return seconds % 60 + "." + millis / 100 % 10; 
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
        
      // Ideally this text would go in the target function but the signature we are required to use limits me from passing the ships index to the function
      if (enableEnemyLifeTimer) {
        textSize(16);
        fill(255);
        text(formatSeconds(targetSpawnTimes[i] + targetLifeTimes[i] - millis()), pos.x, pos.y + targetSizeValues[type].y * 0.6);
      }

      if (checkEllipseCollision(pos, targetSizeValues[type], planetPos, planetSize)) {
        despawnTarget(i);
        updateLives(targetDamageValues[type]);
      }
      
      if (millis() > targetSpawnTimes[i] + targetLifeTimes[i]) {
        if(type == 0) {
          drawShot(rightShipLaserPos, targetPositions[i], friendlyLaserColor);
        } else {
          drawShot(leftShipLaserPos, targetPositions[i], enemyLaserColor);
        }
        despawnTarget(i);
      }
      
    } else {
      spawnTarget(i);
    }
  }
}

void spawnTarget(int index) {
  PVector pos = new PVector();
  
  // Makes friendlies less common than enemies to make the game harder
  // Picking up to 1000 and multiplying the chance by 10 allows for decimal chances to 1 place
  int type = int(((int)random(1, 1001) <= friendlySpawnChance * 10));
  
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
  PVector planetTargetPos = new PVector(planetPos.x + random(-width * 0.4, width * 0.4), planetPos.y);
  targetVelocities[index] = PVector.sub(planetTargetPos, pos).normalize().setMag(random(currentTargetMinSpeed, targetMaxSpeed));
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

// Having math operations for each size value allows for the game to scale if the enemies change size, probably decreases performance
// These values were mostly figured out with trial and error

void target(float x, float y, int typeOfTarget) {
  PVector size = targetSizeValues[typeOfTarget];
  noStroke();
  if (typeOfTarget == 0) { // Enemy
    fill(140, 130, 130);
    rect(x - size.x * 0.2, y - size.y * 0.25, size.x * 0.4, size.y * 0.4); // Middle
    fill(enemyColor);
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
    fill(enemyColor);
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
    fill(friendlyColor);
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
  drawGrid(friendlyColor);
  fill(0);
  rect(centrePos.x - width * 0.3, centrePos.y - height * 0.5, width * 0.6, height * 0.2); // Title Background
  rect(centrePos.x - width * 0.4, centrePos.y - height * 0.25, width * 0.8, height * 0.1); // Paragraph 1
  rect(centrePos.x - width * 0.4, centrePos.y - height * 0.1, width * 0.8, height * 0.1); // Paragraph 2
  rect(centrePos.x - width * 0.1, centrePos.y + height * 0.05, width * 0.2, height * 0.05); // Good Luck  
  rect(centrePos.x - width * 0.45, centrePos.y + height * 0.2, width * 0.2, height * 0.1); // Controls
  rect(width * 0.7, height * 0.7, width * 0.2, height * 0.25); // Targets
  fill(friendlyColor);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Space Defender 2", centrePos.x, centrePos.y - height * 0.4);
  textSize(20);
  text("Click on enemy ships to destroy them, dont let them reach the planet!\nFriendly ships reduce score if killed.", 
        centrePos.x, centrePos.y - height * 0.2);
  text("Friendly ships that reach the planet add lives, Missed shots reduce lives.\nKeep good accuracy to get a higher score.", 
        centrePos.x, centrePos.y - height * 0.05); 
  text("Good Luck!", centrePos.x, centrePos.y + height * 0.075);
  textAlign(LEFT);
  text("[s] Start Game", width * 0.05, height * 0.8);
  text("[q] Quit", width * 0.05, height * 0.85);
  text("Enemy: ",width * 0.71, height * 0.76);
  text("Friendly: ",width * 0.71, height * 0.88);
  target(width * 0.85, height * 0.76, 0);
  target(width * 0.85, height * 0.88, 1);
}

void drawEndScreen() {
  drawGrid(enemyColor);
  fill(0);
  rect(centrePos.x - width * 0.3, centrePos.y - height * 0.5, width * 0.6, height * 0.2); // Title Background
  rect(centrePos.x - width * 0.2, centrePos.y - height * 0.25, width * 0.4, height * 0.5); // Stats
  rect(centrePos.x - width * 0.45, centrePos.y + height * 0.2, width * 0.2, height * 0.15); // Controls
  fill(enemyColor);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Game Over!", centrePos.x, centrePos.y - height * 0.4);
  textSize(40);
  text("Score: " + score, centrePos.x, centrePos.y - height * 0.2);
  text("Kills: " + kills, centrePos.x, centrePos.y - height * 0.1);
  text("Accuracy: " + calcAccuracy() + "%", centrePos.x, centrePos.y);
  text("Time: " + formatTime(millisPassed), centrePos.x, centrePos.y + height * 0.1);
  text("Final Score: " + ceil(score - (score * ( 1 - (calcAccuracy() / 100.)))), centrePos.x, centrePos.y + height * 0.2); // Multiplies score by accuracy
  textAlign(LEFT);
  textSize(20);
  text("[r] New Round", width * 0.05, height * 0.8);
  text("[m] Title Screen", width * 0.05, height * 0.85);
  text("[q] Quit", width * 0.05, height * 0.9);
}

void drawGrid(color oddColor) {
  boolean oddSquare = false;
  noStroke();
  for(int i = 0; i <= menuSquareCountX; i++) {
    for(int k = 0; k <= menuSquareCountY; k++) {
      if(oddSquare) {
        fill(0);
      } else {
        fill(oddColor);
      }
      square(i * menuSquareSize, k * menuSquareSize, menuSquareSize);
      fill(0);
      square(i * menuSquareSize - menuSquareSize * 0.375, k * menuSquareSize - menuSquareSize * 0.375, menuSquareSize * 0.75);
      oddSquare = !oddSquare;
    }
  }
}

void drawInfoArea() {
  noStroke();
  fill(20);
  rect(0, 0, width, infoAreaY);
  textSize(24);
  fill(255);
  textAlign(CENTER, TOP);
  text("Space Defender 2", centrePos.x, infoAreaY / 5);
  text(formatTime(millisPassed), centrePos.x, infoAreaY * 0.5);
  text("Score\n" + score, width * 0.05, infoAreaY / 4);
  text("Kills\n" + kills, width * 0.15, infoAreaY / 4);
  text("Accuracy\n " + calcAccuracy() + "%", width * 0.28, infoAreaY * 0.25);
  text("Lives", width * 0.85, infoAreaY / 4);
  drawLivesBar(new PVector(width * 0.85, infoAreaY * 0.6), new PVector(5, 5), 10, lives);
}

void drawLivesBar(PVector pos, PVector size, float iconDistance, int lives) {
  float barWidth = size.x + iconDistance * (lives + 1);
  float barCentre = (barWidth - size.x) * 0.5;
  for (int i = 1; i <= lives; i++) { 
    fill(0, 255, 0);
    rect(pos.x - size.x * 0.5 - barCentre + iconDistance * i, pos.y, size.x, size.y);
  }
}

void drawCrosshair() {
  for(int i = 0; i < targetCount; i++) {
    int type = targetTypes[i];
    if (checkPointCollision(targetPositions[i], targetSizeValues[type], mousePos)) {
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
  for(int i = 0; i < generatedFarShipCount; i++) {
    
    PVector pos = farShipPositions[i];
    PVector size;
    color laserColor;
    boolean drawShot = (int)random(1, 1001) <= farShipShootChance * 10;
    int tIndex;

    if (i % 2 == 0) { // Enemy Ship
    
      size = farShipSizes[0];
      tIndex = (int)random(1, (generatedFarShipCount + 2) / 2) * 2 - 1; // Picks a random odd number within the bounds of the array representing an enemies index
      laserColor = enemyLaserColor;
      
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.45, pos.y, size.x * 0.2, size.y * 0.3); // Back Middle
      fill(80);
      rect(pos.x - size.x * 0.45, pos.y - size.y * 0.25, size.x * 0.15, size.y * 0.2); // Back Top
      rect(pos.x - size.x * 0.4, pos.y - size.y * 0.5, size.x * 0.05, size.y * 0.25); // Back Middle Top
      rect(pos.x - size.x * 0.35, pos.y - size.y * 0.5, size.x * 0.05, size.y * 0.1); // Right Top
      triangle( // Back Top
        pos.x - size.x * 0.45, pos.y - size.y * 0.25,
        pos.x - size.x * 0.4, pos.y - size.y * 0.5,
        pos.x - size.x * 0.4, pos.y - size.y * 0.25
      );
      fill(80);
      triangle( // Back Top
        pos.x - size.x * 0.35, pos.y - size.y * 0.25,
        pos.x - size.x * 0.35, pos.y - size.y * 0.5,
        pos.x - size.x * 0.3, pos.y - size.y * 0.25
      );
      triangle( // Top Half
        pos.x - size.x * 0.5, pos.y - size.y * 0.2,
        pos.x - size.x * 0.4, pos.y + size.y * 0.1,
        pos.x + size.x * 0.5, pos.y + size.y * 0.1
       );
      triangle( // Bottom Half
        pos.x - size.x * 0.5, pos.y + size.y * 0.5,
        pos.x - size.x * 0.4, pos.y + size.y * 0.2,
        pos.x + size.x * 0.5, pos.y + size.y * 0.2
       );
      fill(enemyColor);
      triangle( // 
        pos.x - size.x * 0.38, pos.y - size.y * 0.05,
        pos.x - size.x * 0.38, pos.y - size.y * 0.3,
        pos.x - size.x * 0.12, pos.y - size.y * 0.05
      );
      fill(140, 130, 130);
      rect(pos.x - size.x * 0.4, pos.y + size.y * 0.1, size.x * 0.8, size.y * 0.1); // Middle
      
    } else { // FriendlyShip
    
      size = farShipSizes[1];
      tIndex = (int)random((generatedFarShipCount + 1) / 2) * 2; // Picks a random even number within the bounds of the array representing an enemies index
      laserColor = friendlyLaserColor;

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
      fill(friendlyColor);
      rect(pos.x - size.x * 0.15, pos.y - size.y * 0.3, size.x * 0.4, size.y * 0.2); // Top Middle
      rect(pos.x - size.x * 0.15, pos.y + size.y * 0.1, size.x * 0.4, size.y * 0.2); // Bottom Middle
      triangle( // Top Back
        pos.x + size.x * 0.35, pos.y - size.y * 0.3,
        pos.x + size.x * 0.5, pos.y - size.y * 0.3,  
        pos.x + size.x * 0.35, pos.y - size.y * 0.1
      );
      triangle( // Bottom Back
        pos.x + size.x * 0.35, pos.y + size.y * 0.3,
        pos.x + size.x * 0.5, pos.y + size.y * 0.3,  
        pos.x + size.x * 0.35, pos.y + size.y * 0.1
      );
    } 

    if (drawShot && generatedFarShipCount > 1) {
      PVector tPos = farShipPositions[tIndex];
      PVector tSize = farShipSizes[0];
      PVector startPos = new PVector(random(pos.x - size.x * 0.5, pos.x + size.x * 0.5), random(pos.y - size.y * 0.5, pos.y + size.y * 0.5));
      PVector endPos = new PVector(random(tPos.x - tSize.x * 0.5, tPos.x + tSize.x * 0.5), random(tPos.y - tSize.y * 0.5, tPos.y + tSize.y * 0.5));
      drawShot(startPos, endPos, laserColor);
    }
    
  }
}
  
 
void drawCloseShips() {
  // Left Ship
  fill(80);
  rect(leftShipPos.x - leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.3, leftShipSize.x * 0.2, leftShipSize.y * 0.6); // Middle
  fill(enemyColor);
  rect(leftShipPos.x + leftShipSize.x * 0.1, leftShipPos.y - leftShipSize.y * 0.05, leftShipSize.x * 0.3, leftShipSize.y * 0.1); // Gun
  triangle( // Glass
    leftShipPos.x - leftShipSize.x * 0.05, leftShipPos.y - leftShipSize.y * 0.15,
    leftShipPos.x - leftShipSize.x * 0.05, leftShipPos.y + leftShipSize.y * 0.15,
    leftShipPos.x + leftShipSize.x * 0.05, leftShipPos.y
  );
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

  // Right Ship
  fill(80);
  rect(rightShipPos.x - rightShipSize.x * 0.4, rightShipPos.y - rightShipSize.y * 0.2, rightShipSize.x * 0.6, rightShipSize.y * 0.4); // Middle
  rect(rightShipPos.x - rightShipSize.x * 0.5, rightShipPos.y - rightShipSize.y * 0.1, rightShipSize.x * 0.1, rightShipSize.y * 0.2); // Left
  rect(rightShipPos.x - rightShipSize.x * 0.2, rightShipPos.y - rightShipSize.y * 0.5, rightShipSize.x * 0.3, rightShipSize.y * 0.2); // Top Middle
  rect(rightShipPos.x + rightShipSize.x * 0.1, rightShipPos.y - rightShipSize.y * 0.45, rightShipSize.x * 0.4, rightShipSize.y * 0.1); // Top Right
  rect(rightShipPos.x - rightShipSize.x * 0.2, rightShipPos.y + rightShipSize.y * 0.3, rightShipSize.x * 0.3, rightShipSize.y * 0.2); // Bottom Middle
  rect(rightShipPos.x + rightShipSize.x * 0.1, rightShipPos.y + rightShipSize.y * 0.35, rightShipSize.x * 0.4, rightShipSize.y * 0.1); // Bottom Right
  fill(140, 130, 130);
  rect(rightShipPos.x + rightShipSize.x * 0.2, rightShipPos.y - rightShipSize.y * 0.15, rightShipSize.x * 0.15, rightShipSize.y * 0.1); // Top Thruster
  rect(rightShipPos.x + rightShipSize.x * 0.2, rightShipPos.y + rightShipSize.y * 0.05, rightShipSize.x * 0.15, rightShipSize.y * 0.1); // Bottom Thruster
  fill(friendlyColor);
  rect(rightShipPos.x - rightShipSize.x * 0.3, rightShipPos.y - rightShipSize.y * 0.025, rightShipSize.x * 0.3, rightShipSize.y * 0.05); // Gun
  rect(rightShipPos.x - rightShipSize.x * 0.3, rightShipPos.y - rightShipSize.y * 0.3, rightShipSize.x * 0.7, rightShipSize.y * 0.1); // Top Middle\
  triangle( // Top Left
    rightShipPos.x - rightShipSize.x * 0.3, rightShipPos.y - rightShipSize.y * 0.3,
    rightShipPos.x - rightShipSize.x * 0.2, rightShipPos.y - rightShipSize.y * 0.5,
    rightShipPos.x - rightShipSize.x * 0.2, rightShipPos.y - rightShipSize.y * 0.3
  );
  triangle( // Top Right
    rightShipPos.x + rightShipSize.x * 0.2, rightShipPos.y - rightShipPos.y * 0.01,
    rightShipPos.x + rightShipSize.x * 0.2, rightShipPos.y - rightShipPos.y * 0.052,
    rightShipPos.x + rightShipSize.x * 0.4, rightShipPos.y - rightShipPos.y * 0.052
  );
  rect(rightShipPos.x - rightShipSize.x * 0.3, rightShipPos.y + rightShipSize.y * 0.2, rightShipSize.x * 0.7, rightShipSize.y * 0.1); // Bottom Middle
  triangle( // Bottom Left
    rightShipPos.x - rightShipSize.x * 0.2, rightShipPos.y + rightShipSize.y * 0.5,
    rightShipPos.x - rightShipSize.x * 0.3, rightShipPos.y + rightShipSize.y * 0.3,
    rightShipPos.x - rightShipSize.x * 0.2, rightShipPos.y + rightShipSize.y * 0.3
  );
  triangle( // Bottom Right
    rightShipPos.x + rightShipSize.x * 0.2, rightShipPos.y + rightShipPos.y * 0.01,
    rightShipPos.x + rightShipSize.x * 0.2, rightShipPos.y + rightShipPos.y * 0.052,
    rightShipPos.x + rightShipSize.x * 0.4, rightShipPos.y + rightShipPos.y * 0.052
  );
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
  fill(plyColor);
  rect(plyShipPos.x - plyShipSize.x * 0.4, plyShipPos.y + plyShipSize.y * 0.2, plyShipSize.x * 0.15, plyShipSize.y * 0.25); // Left Thruster
  rect(plyShipPos.x + plyShipSize.x * 0.25, plyShipPos.y + plyShipSize.y * 0.2, plyShipSize.x * 0.15, plyShipSize.y * 0.25); // Right Thruster
  fill(80);
  rect(plyShipPos.x - plyShipSize.x * 0.4, plyShipPos.y - plyShipSize.y * 0.3, plyShipSize.x * 0.1, plyShipSize.y * 0.3); // Left Gun
  rect(plyShipPos.x + plyShipSize.x * 0.3, plyShipPos.y - plyShipSize.y * 0.3, plyShipSize.x * 0.1, plyShipSize.y * 0.3); // Right Gun
  fill(plyColor);
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
  fill(friendlyColor);
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
      fill(friendlyColor);
      rect(posX, posY, stationSize.x * 0.05, stationSize.y * 0.1);
    }
  }
}
