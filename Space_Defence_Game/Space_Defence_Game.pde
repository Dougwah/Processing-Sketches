// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxShips = 100;
int spaceStationMaxHealth = 5;
PVector spaceStationSize = new PVector(140, 80);
int maxNotifs = 10;
int notifLifeTime = 2000;
float notifRiseSpeed = 0.4;

int starCount = 100;
PVector[] gStarPositions = new PVector[starCount];
color[] gStarColors = new color[starCount];
float[] gStarSizes = new float[starCount];
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
int craters = 15;
int craterMaxSize = 40;
int craterMinSize = 10;
PVector moonPosition;
PVector[] craterPositions = new PVector[craters];
float[] craterSizes = new float[craters];

float xHairX = 3.;
float xHairY = 20.;
float xHairGap = 10.;
color xHairColor = color(255, 255, 255);

// ===== SHIP SETTINGS =====
int FRIGATE = 0;
int CRUISER = 1;
int DESTROYER = 2;
int FRIENDLY = 3;
int CANNONPROJ = 4; // Projectiles have same functionality to ships
int[] shipHitPointValues = {1, 3, 2, 1, 1};
int[] shipDamageValues = {1, 2, 0, -1, 1};
float[] shipSpeedValues = {1.5, 0.5, 0, 1, 0.5};
int[] shipScoreValues = {10, 20, 15, -50, 30};
int[] shipProjectileValues = {-1, -1, 4, -1, -1}; // What projectile the ship fires (-1 if none);
int shipFireDelay = 4000;

PVector[] shipSizeValues = {
  new PVector(70, 30), 
  new PVector(50, 50),
  new PVector(70, 30),
  new PVector(50, 40),
  new PVector(20, 20),
};

// ===== CURRENT ROUND VALUES =====
int score;
int kills;
float shotsTaken;
float shotsHit;
int millisPassed;
int lastMilli;
PVector mousePos = new PVector();
PVector centrePos;
float currentMaxShips;
int spaceStationHealth;

int aliveShips = 0;
int[] ships = new int[maxShips];
PVector[] shipPositions = new PVector[maxShips];
PVector[] shipVelocities = new PVector[maxShips];
boolean[] shipStates = new boolean[maxShips];
int[] shipHitPoints = new int[maxShips];
int[] shipLastFireTimes = new int[maxShips];

void setup() {
  noCursor();
  size(800, 600);
  centrePos = new PVector(width * 0.5, height * 0.5 + (infoAreaY * 0.5));
  newGame();
}

void draw() {
  background(0);
    
  mousePos.x = mouseX;
  mousePos.y = max(mouseY, infoAreaY);
  
  if(aliveShips < currentMaxShips) {
    spawnShip((int)random(4));  
  }
  
  currentMaxShips += 0.001;
  
  drawStars();
  drawBackgroundObjects();
  runNotifs();
  runShips();
  drawCrosshair();
  drawInfoArea();
  
  millisPassed += millis() - lastMilli;
  lastMilli = millis();
}

void mousePressed() {
  int shipIndex = getTargetShip();
  stroke(#FCD300);
  strokeWeight(3);
  shotsTaken++;
  line(centrePos.x + spaceStationSize.x * 0.025 + 3, centrePos.y - spaceStationSize.y * 0.15 + 3, mousePos.x, mousePos.y);
  if (shipIndex > -1 && shipStates[shipIndex]) {
    shotsHit++;
    damageShip(shipIndex, 1);
  }
}

// ===== GAME FUNCTIONS ===== 
void newGame() {
  generateStars();
  generateMoon();
  score = 0;
  kills = 0;
  shotsTaken = 0;
  shotsHit = 0;
  millisPassed = 0;
  lastMilli = millis();
  spaceStationHealth = spaceStationMaxHealth;
  currentMaxShips = 3;
  aliveShips = 0;
  shipStates = new boolean[maxShips];
}

void endGame() {
  newGame();  
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    PVector pos = new PVector(random(width), random(infoAreaY, height));
    gStarPositions[i] = pos;
    gStarColors[i] = starColors[floor(random(starColors.length))];
    gStarSizes[i] = random(1, 3);
  }
}

void generateMoon() {
  moonPosition = new PVector(width * 0.85, height * 0.75);
  for (int i = 0; i < craters; i++) {
    float craterSize = random(craterMinSize, craterMaxSize);
    craterPositions[i] = PVector.add(moonPosition ,new PVector(random(-1, 1), random(-1, 1)).setMag(moonSize / random(2,4) - craterSize / 2));
    craterSizes[i] = craterSize;
  }
}

void damageSpaceStation(int damage) {
  spaceStationHealth = min(spaceStationHealth - damage, spaceStationMaxHealth) ;
  addNotif(-damage, centrePos.x, centrePos.y - spaceStationSize.y * 0.7, 30);
  if (spaceStationHealth <= 0) {
    endGame();  
  }
}

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(floor(seconds / 60), 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
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
void drawStars() {
  for (int i = 0; i < gStarPositions.length; i++)  {
    fill(gStarColors[i]);
    noStroke();
    circle(gStarPositions[i].x, gStarPositions[i].y, gStarSizes[i]);
  }
}

void drawCrosshair() {
  if (getTargetShip() > -1) {
    xHairColor = color(255, 0, 0);
  } else {
    xHairColor = color(255, 255, 255); 
  }
  fill(xHairColor);
  rect(mousePos.x - xHairGap - xHairY, mousePos.y - xHairX * 0.5, xHairY, xHairX); // LEFT
  rect(mousePos.x + xHairGap, mousePos.y - xHairX * 0.5, xHairY, xHairX);              // RIGHT
  rect(mousePos.x - xHairX * 0.5, mousePos.y - xHairY - xHairGap, xHairX, xHairY); // UP
  rect(mousePos.x - xHairX * 0.5, mousePos.y + xHairGap, xHairX, xHairY);              // DOWN
  noFill();
  strokeWeight(xHairX);
  stroke(xHairColor);
  circle(mousePos.x, mousePos.y, xHairY);
  point(mousePos.x, mousePos.y);
}

void drawShip(int index) {
  PVector position = shipPositions[index];
  int shipType = ships[index];
  PVector size = shipSizeValues[shipType];
  noStroke();
  if (ships[index] == FRIGATE) {
    fill(150, 150, 150);
    rect(position.x - size.x / 4, position.y - size.y / 4, size.x * 0.5, size.y * 0.5);
    fill(200, 200, 200);
    circle(position.x, position.y, size.y);
    triangle(
      position.x - size.x * 0.5, 
      position.y,     
      position.x - size.x / 4,
      position.y - size.y / 4,      
      position.x - size.x / 4,
      position.y + size.y / 4
    );
    triangle(
      position.x + size.x * 0.5, 
      position.y,    
      position.x + size.x / 4,
      position.y - size.y / 4,    
      position.x + size.x / 4,
      position.y + size.y / 4
    );
    fill(255, 0, 0);
    rect(position.x - size.x / 6, position.y - size.y / 6, size.x / 3, size.y / 3);
  } else if (ships[index] == CRUISER) {
    fill(150, 150, 150);
    triangle(
      position.x - size.x * 0.4,
      position.y, 
      position.x,
      position.y - size.y * 0.5,          
      position.x + size.x * 0.4,
      position.y
    );
    triangle(
      position.x + size.x * 0.41,
      position.y,
      position.x,
      position.y + size.y * 0.5,        
      position.x - size.x * 0.4,
      position.y
    );
    fill(255, 0, 0);
    square(position.x - size.x * 0.15, position.y - size.y * 0.15, size.y * 0.3);
    fill(200, 200, 200);
    rect(position.x - size.x * 0.5, position.y - size.y * 0.5, size.x, size.y * 0.2);
    rect(position.x - size.x * 0.5, position.y + size.y * 0.3, size.x, size.y * 0.2);
  } else if (ships[index] == DESTROYER) {
    fill(150, 150, 150);
    triangle(
      position.x - size.x * 0.5,
      position.y - size.y * 0.2,    
      position.x,
      position.y - size.y * 0.5,         
      position.x + size.x * 0.5,
      position.y - size.y * 0.2
    );
    rect(position.x - size.x * 0.15, position.y - size.y * 0.25, size.x * 0.3, size.y * 0.5);
    fill(255, 0, 0);
    rect(position.x - size.x * 0.05, position.y - size.y * 0.1, size.x * 0.1, size.y * 0.2);
    fill(150, 150, 150);
    triangle(
      position.x + size.x * 0.5,
      position.y + size.y * 0.2,  
      position.x,
      position.y + size.y * 0.5,        
      position.x - size.x * 0.5,
      position.y + size.y * 0.2
    );
  } else if (ships[index] == CANNONPROJ) {
    fill(255, 0, 0);
    circle(position.x, position.y, size.x);
  } else if (ships[index] == FRIENDLY) {
    fill(150, 150, 150);
    rect(position.x - size.x * 0.5, position.y - size.y * 0.5, size.x * 0.25, size.y);
    rect(position.x + size.x * 0.25, position.y - size.y * 0.5, size.x * 0.25, size.y);
    fill(200, 200, 200);
    circle(position.x, position.y, size.x * 0.5);
    fill(0, 255, 0);
    rect(position.x - size.x * 0.05, position.y - size.y * 0.2, size.x * 0.1, size.y * 0.4);
    rect(position.x - size.x * 0.175, position.y - size.y * 0.06, size.x * 0.35, size.y * 0.12);
  }

  drawHealthBar(position.x, position.y + size.y * 0.7, 5, 5, 10, shipHitPoints[index]);
}

boolean lightOn = false;
int lastLightTime = millis();

void drawBackgroundObjects() {
  // Space Station
  fill(150, 150, 150);
  rect(centrePos.x - spaceStationSize.x * 0.5, centrePos.y - spaceStationSize.y * 0.2, spaceStationSize.x * 0.3, spaceStationSize.y * 0.6); // Left
  rect(centrePos.x + spaceStationSize.x * 0.3, centrePos.y - spaceStationSize.y * 0.5, spaceStationSize.x * 0.2, spaceStationSize.y); // Right
  fill(255, 255, 255);
  rect(centrePos.x + spaceStationSize.x * 0.35, centrePos.y - spaceStationSize.y * 0.4, spaceStationSize.x * 0.1, spaceStationSize.y * 0.8); // Right Light
  fill(150, 150, 150);
  rect(centrePos.x, centrePos.y - spaceStationSize.y * 0.2, spaceStationSize.x * 0.1, spaceStationSize.y * 0.2); // Middle Top
  fill(#FCD300);
  rect(centrePos.x + spaceStationSize.x * 0.025, centrePos.y - spaceStationSize.y * 0.15, spaceStationSize.x * 0.05, spaceStationSize.y * 0.1); // Laser Origin
  fill(150, 150, 150);
  rect(centrePos.x - spaceStationSize.x * 0.45, centrePos.y - spaceStationSize.y * 0.5, spaceStationSize.x * 0.05, spaceStationSize.y * 0.4); // Left antenna
  
  if (millis() > lastLightTime + 1000){
    lightOn = !lightOn;
    lastLightTime = millis();
  } 
  
  if (lightOn) {
    fill(0, 255, 0);
  } else {
    fill(100, 100, 100); 
  }
  
  rect(centrePos.x - spaceStationSize.x * 0.45, centrePos.y - spaceStationSize.y * 0.5, spaceStationSize.x * 0.05, spaceStationSize.y * 0.1); // Left antenna Light
  fill(150, 150, 150);
  rect(centrePos.x - spaceStationSize.x * 0.35, centrePos.y - spaceStationSize.y * 0.3, spaceStationSize.x * 0.05, spaceStationSize.y * 0.15); // Right antenna
  rect(centrePos.x - spaceStationSize.x * 0.2, centrePos.y, spaceStationSize.x * 0.5, spaceStationSize.y * 0.25); // Middle Bottom
  
  // Moon
  fill(220, 220, 220);
  circle(moonPosition.x, moonPosition.y, 200);
  for (int i = 0; i < craters; i++) {
    PVector pos = craterPositions[i];
    fill(170, 170, 170); 
    circle(pos.x, pos.y, craterSizes[i]);  
  }
  
  // Left Ship
  
  // Right Ship
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
  text("Accuracy\n " + round((shotsHit + 1) / (shotsTaken + 1) * 10000) / 100 + "%", width * 0.28, infoAreaY * 0.25);
  text("Lives", width * 0.85, infoAreaY / 4);
  
  drawHealthBar(width * 0.85, infoAreaY * 0.6, 20, 20, 30, spaceStationHealth);
}

void drawHealthBar(float posX, float posY, int sizeX, int sizeY, float iconDistance, int health) {
  float barWidth = sizeX + iconDistance * (health + 1);
  float barCentre = barWidth * 0.5 - (sizeX * 0.5);
  for (int i = 1; i <= health; i++) { 
    fill(0, 255, 0);
    rect(posX - sizeX / 2 - barCentre + iconDistance * i, posY, sizeX, sizeY);
  }
}

// ===== NOTIFICATION FUNCTIONS =====
PVector[] notifPositions = new PVector[maxNotifs];
String[] notifStrings = new String[maxNotifs];
color[] notifColors = new color[maxNotifs];
int[] notifSizes = new int[maxNotifs];
int[] notifSpawnTimes = new int[maxNotifs];
boolean[] activeNotifs = new boolean[maxNotifs];

void addNotif(int statValue, float posX, float posY, int size) {
  int index = findNextInactiveNotif();
  
  String str = str(statValue);
  if (statValue > 0) {
    str = "+ " + str;
    notifColors[index] = color(0, 255, 0);
  } else {
    notifColors[index] = color(255, 0, 0);  
  }
  
  notifPositions[index] = new PVector(posX, posY);
  notifStrings[index] = str;
  
  notifSpawnTimes[index] = millis(); 
  activeNotifs[index] = true;
  notifSizes[index] = size;
}

void runNotifs() {
  textAlign(CENTER, CENTER);
  for (int i = 0; i < maxNotifs; i++) {
    if (!activeNotifs[i]) {
      continue;  
    }
    
    if (millis() > notifSpawnTimes[i] + notifLifeTime) {
      activeNotifs[i] = false;  
    }

    PVector position = notifPositions[i];
    position.y -= notifRiseSpeed;
    textSize(notifSizes[i]);
    fill(notifColors[i]);
    text(notifStrings[i], position.x, position.y);
  }
}

int findNextInactiveNotif() {
  for (int i = 0; i < maxNotifs; i++) {
    if (!activeNotifs[i]) {
      return i;
    }
  }
  return -1;  
}

// ===== ENEMY FUNCTIONS =====
int findNextDeadShip() {
  for (int i = 0; i < maxShips; i++) {
    if (!shipStates[i]) {
      return i;
    }
  }
  return -1;
}

int getTargetShip() {
  for (int i = 0; i < maxShips; i++) {
    if (!shipStates[i]) { 
      continue; 
    }
    
    if (checkCollision(shipPositions[i], shipSizeValues[ships[i]], mousePos)) {
      return i;  
    }
  }
  return -1;
}

void spawnShip(int shipType) {
  int index = findNextDeadShip();
  if (index == -1) { 
    return; 
  }
  
  PVector size = shipSizeValues[shipType];
  float shipSpeed = shipSpeedValues[shipType];
  PVector position;

  if (shipSpeed > 0) { // Moving ships spawn on the edge of the screen, stationary ships spawn a random distance from the station
    if (boolean((int)random(2))) { // spawn on X or Y edges
      float posY;
      if (boolean((int)random(2))) {
        posY = height - size.y * 0.5; // Bottom
      } else {
        posY = infoAreaY + size.y * 0.5; // Top
      }
      position = new PVector(random(size.x * 0.5, width), posY);
    } else {
      float posX;
      if (boolean((int)random(2))) {
        posX = size.x * 0.5; // Left
      } else {
        posX = width - size.x * 0.5; // Right
      }
      position = new PVector(posX, random(infoAreaY + size.y, height - size.y * 0.5));
    }
    PVector velocity = PVector.sub(centrePos, position);
    shipVelocities[index] = velocity.setMag(shipSpeed);
  } else {
    position = PVector.add(centrePos, new PVector(random(-1, 1), random(-1, 1)).setMag(height * 0.5 - infoAreaY));
    shipVelocities[index] = new PVector(0, 0);
  }
  
  aliveShips++;
  ships[index] = shipType;
  shipStates[index] = true;
  shipHitPoints[index] = shipHitPointValues[shipType];
  shipPositions[index] = position;
  shipLastFireTimes[index] = millis() - shipFireDelay;
}

void spawnShip(int shipType, PVector position) {
  int index = findNextDeadShip();
  if (index == -1) { 
    return; 
  }
  PVector velocity = PVector.sub(centrePos, position);
  
  aliveShips++;
  ships[index] = shipType;
  shipStates[index] = true;
  shipHitPoints[index] = shipHitPointValues[shipType];
  shipPositions[index] = position.copy();
  shipVelocities[index] = velocity.setMag(shipSpeedValues[shipType]);
}

void killShip(int index) {
  aliveShips--;
  shipStates[index] = false;
}

void damageShip(int index, int damage) {
  shipHitPoints[index] -= damage;
  if (shipHitPoints[index] <= 0) {
    killShip(index);
    kills++;
    int shipScore = shipScoreValues[ships[index]];
    score += shipScore;
    PVector position = shipPositions[index];
    PVector shipSize = shipSizeValues[ships[index]];
    addNotif(shipScore, position.x, position.y - shipSize.y * 0.7, 30);
  }
}

void moveShip(int index) {
  shipPositions[index].add(shipVelocities[index]);  
}

void fireShipProjectile(int index) {
  int projectile = shipProjectileValues[ships[index]];
  if (projectile < 0) {
    return;  
  }

  if (millis() > shipLastFireTimes[index] + shipFireDelay) {
    spawnShip(CANNONPROJ, shipPositions[index]);
    shipLastFireTimes[index] = millis();
  }
}

void runShips() {
  for (int i = 0; i < maxShips; i++) {
    if (!shipStates[i]) { 
      continue; 
    }
    
    if (checkCollision(shipPositions[i], shipSizeValues[ships[i]], centrePos, spaceStationSize)) {
      killShip(i);
      damageSpaceStation(shipDamageValues[ships[i]]);
    }
    
    moveShip(i);
    fireShipProjectile(i);  
    drawShip(i);
  }
}

// add spawn chances
// add start menu, start, quit, display tutorial
// add game over screen
// design 2 background ships

/*
Background is the correct size                                            2  X
There is a start screen                                                   2
User can only move to the game screen when a key is pressed               2
Game screen has 2 sections and at least 4 shapes to add visual interest   6
Score and lives are displayed using variables                             3  X
Target is a composite shape                                               12 X
Cross hairs are a composite shape                                         12 X
Target appears at a random location                                       2  X
A target is hit if the cross hairs and target collide                     10 X
If a target is hit it should disappear                                    5  X
When the target reappears the type of target is randomized                5  X
When target reappears, its location is randomized                         5  X
Target and cross hairs should be limited to the game area ONLY            5  X
All of the target should be confined to the game area                     2  X
Score and lives update as per the target and if it was a successful hit   6  X ?
No key presses should work on the game screen                             2  X
There is a finite end to game                                             4  X
When game ends it moves to final screen with detail displayed             4
Pressing a key should bring user back to game screen 4                    4
Upon returning to game screen, scores and lives reset 2                   2 X
Creativity                                                                5 X
*/
