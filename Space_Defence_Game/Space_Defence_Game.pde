// GAME SETTINGS
int infoAreaY = 50;
int maxEnemies = 10;

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
int CANNONPROJ = 3;
int[] enemyHitPointValues = {1, 5, 3, 1};
int[] enemyDamageValues = {1, 2, 0, 3};
float[] enemySpeedValues = {1.5, 0.5, 1, 2};
int[] enemyScoreValues = {10, 20, 15, 30};
PVector[] enemySizes = {new PVector(50, 25), new PVector(50, 50)};

// PROJECTILE TYPES
int CANNON = 0;
int[] projHealthValues = {1};
int[] projDamageValues = {3};
int[] projSpeedValues = {3};
int[] projPointValues = {30};

// CURRENT ROUND VALUES
int score;
int millisPassed;
int lastMilli;
boolean gameStarted = false;
PVector mousePos;
PVector centerPos;
int currentEnemyCount = 3;

int aliveEnemies = 0;
int[] enemyTypes = new int[maxEnemies];
PVector[] enemyPositions = new PVector[maxEnemies];
PVector[] enemyVelocities = new PVector[maxEnemies];
boolean[] enemyStates = new boolean[maxEnemies];
int[] enemyHitPoints = new int[maxEnemies];

void setup() {
  noCursor();
  size(800, 600);
  centerPos = new PVector(width / 2, height / 2);
}

void draw() {
  background(0);
  
  if (!gameStarted) {
    newGame();  
  }
  
  mousePos = new PVector(mouseX, max(mouseY, infoAreaY));
  
  if(aliveEnemies < currentEnemyCount) {
    spawnEnemy((int)random(2));  
  }
  
  drawStars();
  drawSpaceStation();
  runEnemies();
  drawCrosshair();
  drawInfoArea();
}

// GAME FUNCTIONS
void newGame() {
  println("New Game");
  generateStars();
  score = 0;
  millisPassed = 0;
  lastMilli = 0;
  aliveEnemies = 0;
  enemyStates = new boolean[maxEnemies];
  gameStarted = true;
}

void generateStars() {
  for (int i = 0; i < starCount; i++) {
    PVector pos = new PVector(random(0, width), random(0, height));
    gStarPositions[i] = pos;
    gStarColors[i] = starColors[floor(random(starColors.length))];
    gStarSizes[i] = random(1, 3);
    println(gStarSizes[i]);
  }
}

void mousePressed() {
  int enemyIndex = getTargetEnemy();
  stroke(#FCD300);
  strokeWeight(3);
  line(centerPos.x, centerPos.y, mousePos.x, mousePos.y);
  if (enemyIndex > -1 && enemyStates[enemyIndex]) {
    damageEnemy(enemyIndex, 1);
  }
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
  if (getTargetEnemy() > -1) {
    xHairColor = color(255, 0, 0);
  } else {
    xHairColor = color(255, 255, 255); 
  }
  fill(xHairColor);
  rect(mousePos.x - xHairGap - crossHairY, mousePos.y - crossHairX / 2, crossHairY, crossHairX); // LEFT
  rect(mousePos.x + xHairGap, mousePos.y - crossHairX / 2, crossHairY, crossHairX);              // RIGHT
  rect(mousePos.x - crossHairX / 2, mousePos.y - crossHairY - xHairGap, crossHairX, crossHairY); // UP
  rect(mousePos.x - crossHairX / 2, mousePos.y + xHairGap, crossHairX, crossHairY);              // DOWN
  noFill();
  strokeWeight(crossHairX);
  stroke(xHairColor);
  circle(mousePos.x, mousePos.y, crossHairY);
  point(mousePos.x, mousePos.y);
}

void drawSpaceStation() {
  fill(#08CFFF);
  noStroke();
  rect(centerPos.x - spaceStationSize.x / 2, centerPos.y - spaceStationSize.y / 2, spaceStationSize.x, spaceStationSize.y);   
}

void drawEnemy(int index) {
  PVector position = enemyPositions[index];
  int enemyType = enemyTypes[index];
  PVector size = enemySizes[enemyType];
  noStroke();
  fill(200, 200, 200);
  if (enemyTypes[index] == FRIGATE) {
    rect(position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
    //triangle(position.x - size, position.y - size / 2, position.x, position.y - size, position.x + size, position.y - size / 2);
    //triangle(position.x - size, position.y + size / 2, position.x, position.y + size, position.x + size, position.y + size / 2);
    //circle(position.x, position.y, size);
    //fill(255 , 0, 0);
    //circle(position.x, position.y, size / 2);
  } else if (enemyTypes[index] == CRUISER) {
    rect(position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
  } else if (enemyTypes[index] == DESTROYER) {
  
  }
}

void drawInfoArea() {
  noStroke();
  fill(255, 255, 255);
  rect(0, 0, width, infoAreaY);
}

// ENEMY FUNCTIONS
int findNextDeadEnemy() {
  for (int i = 0; i < enemyStates.length; i++) {
    if (!enemyStates[i]) {
      return i;
    }
  }
  return -1;
}

int getTargetEnemy() {
  for (int i = 0; i < enemyPositions.length; i++) {
    if (!enemyStates[i]) { 
      continue; 
    }
    
    //int enemyType = enemyTypes[i];
    //PVector enemySize = enemySizes[enemyType];
    //if (PVector.sub(enemyPositions[i], mousePos).mag() < enemySize) {
    //  return i;      
    //}
    if (checkCollision(enemyPositions[i], enemySizes[enemyTypes[i]], mousePos, new PVector(5, 5))) {
      return i;  
    }
  }
  return -1;
}

void spawnEnemy(int enemyType) {
  int index = findNextDeadEnemy();
  if (index == -1) { 
    return; 
  }
  
  PVector size = enemySizes[enemyType];
  PVector position;
 
  //if (boolean((int)random(2))) {
  //    position = new PVector(random(width), height - size - ((int)random(2) * (height - infoAreaY - size * 2))); // Spawn on top or bottom of screen
  //} else {
  //    position = new PVector(width - size - ((int)random(2) * (width - size * 2)), random(infoAreaY + size, height - size)); // Spawn left or right of screen
  //}
  
  if (boolean((int)random(2))) {
    float posY;
    if (boolean((int)random(2))) {
      posY = height - size.y; // Bottom
    } else {
      posY = infoAreaY + size.y; // Top
    }
    position = new PVector(random(width), posY);
  } else {
    float posX;
    if (boolean((int)random(2))) {
      posX = size.x; // Left
    } else {
      posX = width - size.x; // Right
    }
    position = new PVector(posX, random(infoAreaY + size.y, height - size.y));
  }
  
  PVector velocity = PVector.sub(centerPos, position);
  
  aliveEnemies++;
  enemyTypes[index] = enemyType;
  enemyStates[index] = true;
  enemyHitPoints[index] = enemyHitPointValues[enemyType];
  enemyPositions[index] = position;
  enemyVelocities[index] = velocity.setMag(enemySpeedValues[enemyType]);
}

void killEnemy(int index) {
  aliveEnemies--;
  enemyStates[index] = false;
}

void damageEnemy(int index, int damage) {
  enemyHitPoints[index] -= damage;
  if (enemyHitPoints[index] <= 0) {
    killEnemy(index);
    score += enemyScoreValues[enemyTypes[index]];
  }
}

void moveEnemy(int index) {
  enemyPositions[index].add(enemyVelocities[index]);  
}

boolean checkCollision(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  // if right side of rect 1 is less than the left side of rect 2 
  // or the left side of rect 1 is greater than the right side of rect 2
  if (pos1.x + size1.x / 2 < pos2.x - size2.x / 2 || pos1.x - size1.x / 2 > pos2.x + size2.x / 2) {
    return false; 
  }
  
  // if the top side of rect 1 is less than the top side of rect 2
  // or the bottom side of rect 1 is greater than the bottom side of rect 2
  if (pos1.y + size1.y / 2 < pos2.y - size2.y / 2 || pos1.y - size1.y / 2 > pos2.y + size2.y / 2) {
    return false; 
  }
  
  return true;
  //if (PVector.sub(enemyPositions[index], centerPos).mag() < spaceStationDiameter) {
  //  killEnemy(index);  
  //}
}

void runEnemies() {
  for (int i = 0; i < enemyPositions.length; i++) {
    if (!enemyStates[i]) { 
      continue; 
    }
    moveEnemy(i);
    if (checkCollision(enemyPositions[i], enemySizes[enemyTypes[i]], centerPos, spaceStationSize)) {
      killEnemy(i);
      //damageStation();
    }
    drawEnemy(i);
  }
}
