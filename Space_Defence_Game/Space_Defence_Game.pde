// ===== GAME SETTINGS ===== 
int infoAreaY = 80;
int maxShips = 20;
int stationMaxHealth = 5;
PVector stationSize = new PVector(140, 80);
int maxNotifs = 15;
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
PVector moonPos;
PVector[] craterPositions = new PVector[craters];
float[] craterSizes = new float[craters];

PVector xHairSize = new PVector(3, 20);
int xHairGap = 10;
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
int[] shipSpawnChances = {100, 80, 60, 50, 0};
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
int stationHealth;
boolean lightOn = false;
int lastLightTime = millis();

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
  
  if(aliveShips < min(currentMaxShips, maxShips)) {
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
  line(centrePos.x + stationSize.x * 0.025 + 3, centrePos.y - stationSize.y * 0.15 + 3, mousePos.x, mousePos.y);
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
  stationHealth = stationMaxHealth;
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
  moonPos= new PVector(width * 0.85, height * 0.75);
  for (int i = 0; i < craters; i++) {
    float craterSize = random(craterMinSize, craterMaxSize);
    craterPositions[i] = PVector.add(moonPos,new PVector(random(-1, 1), random(-1, 1)).setMag(moonSize / random(2,4) - craterSize / 2));
    craterSizes[i] = craterSize;
  }
}

void damageStation(int damage) {
  stationHealth = min(stationHealth - damage, stationMaxHealth) ;
  addNotif(-damage, centrePos.x, centrePos.y - stationSize.y * 0.7, 30);
  if (stationHealth <= 0) {
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

void drawShip(int index) {
  PVector pos = shipPositions[index];
  int shipType = ships[index];
  PVector size = shipSizeValues[shipType];
  noStroke();
  if (ships[index] == FRIGATE) {
    fill(150, 150, 150);
    rect(pos.x - size.x / 4, pos.y - size.y / 4, size.x * 0.5, size.y * 0.5);
    fill(200, 200, 200);
    circle(pos.x, pos.y, size.y);
    triangle(
      pos.x - size.x * 0.5, 
      pos.y,     
      pos.x - size.x / 4,
      pos.y - size.y / 4,      
      pos.x - size.x / 4,
      pos.y + size.y / 4
    );
    triangle(
      pos.x + size.x * 0.5, 
      pos.y,    
      pos.x + size.x / 4,
      pos.y - size.y / 4,    
      pos.x + size.x / 4,
      pos.y + size.y / 4
    );
    fill(255, 0, 0);
    rect(pos.x - size.x / 6, pos.y - size.y / 6, size.x / 3, size.y / 3);
  } else if (ships[index] == CRUISER) {
    fill(150, 150, 150);
    triangle(
      pos.x - size.x * 0.4,
      pos.y, 
      pos.x,
      pos.y - size.y * 0.5,          
      pos.x + size.x * 0.4,
      pos.y
    );
    triangle(
      pos.x + size.x * 0.41,
      pos.y,
      pos.x,
      pos.y + size.y * 0.5,        
      pos.x - size.x * 0.4,
      pos.y
    );
    fill(255, 0, 0);
    square(pos.x - size.x * 0.15, pos.y - size.y * 0.15, size.y * 0.3);
    fill(200, 200, 200);
    rect(pos.x - size.x * 0.5, pos.y - size.y * 0.5, size.x, size.y * 0.2);
    rect(pos.x - size.x * 0.5, pos.y + size.y * 0.3, size.x, size.y * 0.2);
  } else if (ships[index] == DESTROYER) {
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
  } else if (ships[index] == CANNONPROJ) {
    fill(255, 0, 0);
    circle(pos.x, pos.y, size.x);
  } else if (ships[index] == FRIENDLY) {
    fill(150, 150, 150);
    rect(pos.x - size.x * 0.5, pos.y - size.y * 0.5, size.x * 0.25, size.y);
    rect(pos.x + size.x * 0.25, pos.y - size.y * 0.5, size.x * 0.25, size.y);
    fill(200, 200, 200);
    circle(pos.x, pos.y, size.x * 0.5);
    fill(0, 255, 0);
    rect(pos.x - size.x * 0.05, pos.y - size.y * 0.2, size.x * 0.1, size.y * 0.4);
    rect(pos.x - size.x * 0.175, pos.y - size.y * 0.06, size.x * 0.35, size.y * 0.12);
  }

  drawHealthBar(pos.x, pos.y + size.y * 0.7, 6, 6, 10, shipHitPoints[index]);
}

PVector lShipSize = new PVector(300, 120);
PVector rShipSize = new PVector(300, 120);
PVector lShipPos = new PVector(180, 180);
PVector rShipPos = new PVector(620, 180);

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
  
  // Moon
  fill(220, 220, 220);
  circle(moonPos.x, moonPos.y, 200);
  for (int i = 0; i < craters; i++) {
    PVector pos = craterPositions[i];
    fill(170, 170, 170); 
    circle(pos.x, pos.y, craterSizes[i]);  
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
  beginShape(); // Main Structure
    vertex(lShipPos.x - lShipSize.x * 0.4, lShipPos.y - lShipSize.y * 0.1);
    vertex(lShipPos.x - lShipSize.x * 0.42, lShipPos.y - lShipSize.y * 0.2);
    vertex(lShipPos.x - lShipSize.x * 0.36, lShipPos.y - lShipSize.y * 0.17);
    vertex(lShipPos.x - lShipSize.x * 0.4, lShipPos.y - lShipSize.y * 0.3);
    vertex(lShipPos.x - lShipSize.x * 0.17, lShipPos.y - lShipSize.y * 0.25);
    vertex(lShipPos.x - lShipSize.x * 0.15, lShipPos.y - lShipSize.y * 0.15);
    vertex(lShipPos.x - lShipSize.x * 0.13, lShipPos.y - lShipSize.y * 0.15);
    vertex(lShipPos.x - lShipSize.x * 0.1, lShipPos.y);
  endShape();
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
  
  drawHealthBar(width * 0.85, infoAreaY * 0.6, 20, 20, 30, stationHealth);
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
    str = "+" + str;
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

    PVector pos = notifPositions[i];
    pos.y -= notifRiseSpeed;
    textSize(notifSizes[i]);
    fill(notifColors[i]);
    text(notifStrings[i], pos.x, pos.y);
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
  PVector pos;

  if (shipSpeed > 0) { // Moving ships spawn on the edge of the screen, stationary ships spawn a random distance from the station
    if (boolean((int)random(2))) { // spawn on X or Y edges
      float posY;
      if (boolean((int)random(2))) {
        posY = height - size.y * 0.5; // Bottom
      } else {
        posY = infoAreaY + size.y * 0.5; // Top
      }
      pos = new PVector(random(size.x * 0.5, width), posY);
    } else {
      float posX;
      if (boolean((int)random(2))) {
        posX = size.x * 0.5; // Left
      } else {
        posX = width - size.x * 0.5; // Right
      }
      pos = new PVector(posX, random(infoAreaY + size.y, height - size.y * 0.5));
    }
    PVector velocity = PVector.sub(centrePos, pos);
    shipVelocities[index] = velocity.setMag(shipSpeed);
  } else {
    pos = PVector.add(centrePos, new PVector(random(-1, 1), random(-1, 1)).setMag(height * 0.5 - infoAreaY));
    shipVelocities[index] = new PVector(0, 0);
  }
  
  aliveShips++;
  ships[index] = shipType;
  shipStates[index] = true;
  shipHitPoints[index] = shipHitPointValues[shipType];
  shipPositions[index] = pos;
  shipLastFireTimes[index] = millis() - shipFireDelay;
}

void spawnShip(int shipType, PVector pos) {
  int index = findNextDeadShip();
  if (index == -1) { 
    return; 
  }
  PVector velocity = PVector.sub(centrePos, pos);
  
  aliveShips++;
  ships[index] = shipType;
  shipStates[index] = true;
  shipHitPoints[index] = shipHitPointValues[shipType];
  shipPositions[index] = pos.copy();
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
    PVector pos = shipPositions[index];
    PVector shipSize = shipSizeValues[ships[index]];
    addNotif(shipScore, pos.x, pos.y - shipSize.y * 0.7, 30);
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
    
    if (checkCollision(shipPositions[i], shipSizeValues[ships[i]], centrePos, stationSize)) {
      killShip(i);
      damageStation(shipDamageValues[ships[i]]);
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
