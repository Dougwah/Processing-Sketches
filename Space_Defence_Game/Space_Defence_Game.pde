// GAME SETTINGS
int infoAreaY = 80;
int maxShips = 10;

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

PVector spaceStationSize = new PVector(100, 80);

float crossHairX = 3.;
float crossHairY = 20.;
float xHairGap = 10.;
color xHairColor = color(255, 255, 255);

// ENEMY SETTINGS
int FRIGATE = 0;
int CRUISER = 1;
int DESTROYER = 2;
int FRIENDLY = 3;
int CANNONPROJ = 4;
int[] shipHitPointValues = {1, 5, 3, 1, 1};
int[] shipDamageValues = {1, 2, 0, 0, 3};
float[] shipSpeedValues = {1.5, 0.5, 1, 1, 2};
int[] shipScoreValues = {10, 20, 15, -50, 30};
int[] shipTargetDistanceValues = {};

PVector[] shipSizeValues = {
  new PVector(70, 30), 
  new PVector(50, 50),
  new PVector(30, 30),
  new PVector(60, 40),
};

// PROJECTILE TYPES
int CANNON = 0;
int[] projHealthValues = {1};
int[] projDamageValues = {3};
int[] projSpeedValues = {3};
int[] projPointValues = {30};

// CURRENT ROUND VALUES
int score;
int kills;
int millisPassed;
int lastMilli;
PVector mousePos;
PVector centerPos;
int currentShipCount;
int spaceStationHealth;

int aliveShips = 0;
int[] ships = new int[maxShips];
PVector[] shipPositions = new PVector[maxShips];
PVector[] shipVelocities = new PVector[maxShips];
boolean[] shipStates = new boolean[maxShips];
int[] shipHitPoints = new int[maxShips];

void setup() {
  noCursor();
  size(800, 600);
  centerPos = new PVector(width * 0.5, height * 0.5 + (infoAreaY * 0.5));
  newGame();
}

void draw() {
  background(0);
    
  mousePos = new PVector(mouseX, max(mouseY, infoAreaY));
  
  if(aliveShips < currentShipCount) {
    spawnShip((int)random(3));  
  }
  
  drawStars();
  drawSpaceStation();
  runShips();
  drawCrosshair();
  drawInfoArea();
  
  millisPassed += millis() - lastMilli;
  lastMilli = millis();
}

// GAME FUNCTIONS
void newGame() {
  generateStars();
  score = 0;
  kills = 0;
  millisPassed = 0;
  lastMilli = millis();
  spaceStationHealth = 5;
  currentShipCount = 3;
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

void mousePressed() {
  int shipIndex = getTargetShip();
  stroke(#FCD300);
  strokeWeight(3);
  line(centerPos.x, centerPos.y, mousePos.x, mousePos.y);
  if (shipIndex > -1 && shipStates[shipIndex]) {
    damageShip(shipIndex, 1);
  }
}

void damageSpaceStation(int damage) {
  spaceStationHealth -= damage;
  if (spaceStationHealth <= 0) {
    endGame();  
  }
}

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(floor(seconds / 60), 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
}

// DRAW FUNCTIONS
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
  rect(mousePos.x - xHairGap - crossHairY, mousePos.y - crossHairX * 0.5, crossHairY, crossHairX); // LEFT
  rect(mousePos.x + xHairGap, mousePos.y - crossHairX * 0.5, crossHairY, crossHairX);              // RIGHT
  rect(mousePos.x - crossHairX * 0.5, mousePos.y - crossHairY - xHairGap, crossHairX, crossHairY); // UP
  rect(mousePos.x - crossHairX * 0.5, mousePos.y + xHairGap, crossHairX, crossHairY);              // DOWN
  noFill();
  strokeWeight(crossHairX);
  stroke(xHairColor);
  circle(mousePos.x, mousePos.y, crossHairY);
  point(mousePos.x, mousePos.y);
}

void drawSpaceStation() {
  fill(#08CFFF);
  noStroke();
  rect(centerPos.x - spaceStationSize.x * 0.5, centerPos.y - spaceStationSize.y * 0.5, spaceStationSize.x, spaceStationSize.y);   
}

void drawShip(int index) {
  PVector position = shipPositions[index];
  int shipType = ships[index];
  PVector size = shipSizeValues[shipType];
  noStroke();
  if (ships[index] == FRIGATE) {
    fill(200, 200, 200);
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
    fill(200, 200, 200);
    triangle(
      position.x - size.x * 0.4,
      position.y,
      
      position.x,
      position.y - size.y * 0.5,
           
      position.x + size.x * 0.4,
      position.y
    );
    triangle(
      position.x + size.x * 0.4,
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
    fill(200, 200, 200);
    rect(position.x - size.x * 0.5, position.y - size.y * 0.5, size.x, size.y);
  } else if (ships[index] == FRIENDLY) {
   
  }
  fill(255);
  textAlign(CENTER, TOP);
  textSize(20);
  text(shipHitPoints[index], position.x, position.y + size.y * 0.5);
}

PVector hpIconSize = new PVector(20, 25);
float hpIconDistance = 30;

void drawInfoArea() {
  noStroke();
  fill(#626262);
  rect(0, 0, width, infoAreaY);
  textSize(24);
  fill(255);
  textAlign(CENTER, TOP);
  text("Space Defender", centerPos.x, infoAreaY / 5);
  text(formatMillis(millisPassed), centerPos.x, infoAreaY * 0.5);
  text("Score\n" + score, width * 0.10, infoAreaY / 4);
  text("Kills\n" + kills, width * 0.25, infoAreaY / 4);
  text("Lives", width * 0.85, infoAreaY / 4);

  float listWidth = hpIconSize.x + hpIconDistance * (spaceStationHealth + 1);
  float listCentre = listWidth * 0.5 - (hpIconSize.x * 0.5);
  for (int i = 1; i <= spaceStationHealth; i++) {
    PVector iconPos = new PVector(((width * 0.84 - listCentre) + hpIconDistance * i), infoAreaY * 0.6);
    fill(0, 255, 0);
    rect(iconPos.x, iconPos.y, hpIconSize.x, hpIconSize.y);
  }
}

// ENEMY FUNCTIONS
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
    
    //int shipType = ships[i];
    //PVector shipSize = shipSizeValues[shipType];
    //if (PVector.sub(shipPositions[i], mousePos).mag() < shipSize) {
    //  return i;      
    //}
    if (checkCollision(shipPositions[i], shipSizeValues[ships[i]], mousePos, new PVector(5, 5))) {
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
  PVector position;
 
  //if (boolean((int)random(2))) {
  //    position = new PVector(random(width), height - size - ((int)random(2) * (height - infoAreaY - size * 2))); // Spawn on top or bottom of screen
  //} else {
  //    position = new PVector(width - size - ((int)random(2) * (width - size * 2)), random(infoAreaY + size, height - size)); // Spawn left or right of screen
  //}
  
  if (boolean((int)random(2))) {
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
  
  PVector velocity = PVector.sub(centerPos, position);
  
  aliveShips++;
  ships[index] = shipType;
  shipStates[index] = true;
  shipHitPoints[index] = shipHitPointValues[shipType];
  shipPositions[index] = position;
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
    score += shipScoreValues[ships[index]];
  }
}

void moveShip(int index) {
  shipPositions[index].add(shipVelocities[index]);  
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

void runShips() {
  for (int i = 0; i < maxShips; i++) {
    if (!shipStates[i]) { 
      continue; 
    }
    moveShip(i);
    if (checkCollision(shipPositions[i], shipSizeValues[ships[i]], centerPos, spaceStationSize)) {
      killShip(i);
      damageSpaceStation(shipDamageValues[ships[i]]);
    }
    drawShip(i);
  }
}
