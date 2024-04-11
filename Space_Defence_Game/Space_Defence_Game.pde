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
PVector mousePos;
PVector centerPos;
int currentEnemyCount;
int spaceStationHealth;

int aliveEnemies = 0;
int[] enemies = new int[maxEnemies];
PVector[] enemyPositions = new PVector[maxEnemies];
PVector[] enemyVelocities = new PVector[maxEnemies];
boolean[] enemyStates = new boolean[maxEnemies];
int[] enemyHitPoints = new int[maxEnemies];

void setup() {
  noCursor();
  size(800, 600);
  centerPos = new PVector(width / 2, height / 2);
  newGame();
}

void draw() {
  background(0);
    
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
  generateStars();
  score = 0;
  millisPassed = 0;
  lastMilli = 0;
  spaceStationHealth = 5;
  currentEnemyCount = 3;
  aliveEnemies = 0;
  enemyStates = new boolean[maxEnemies];
}

void endGame() {
  newGame();  
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

void damageSpaceStation(int damage) {
  spaceStationHealth -= damage;
  if (spaceStationHealth <= 0) {
    endGame();  
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
  int enemyType = enemies[index];
  PVector size = enemySizes[enemyType];
  noStroke();
  fill(200, 200, 200);
  if (enemies[index] == FRIGATE) {
    rect(position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
    //triangle(position.x - size, position.y - size / 2, position.x, position.y - size, position.x + size, position.y - size / 2);
    //triangle(position.x - size, position.y + size / 2, position.x, position.y + size, position.x + size, position.y + size / 2);
    //circle(position.x, position.y, size);
    //fill(255 , 0, 0);
    //circle(position.x, position.y, size / 2);
  } else if (enemies[index] == CRUISER) {
    rect(position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
  } else if (enemies[index] == DESTROYER) {
  
  }
  textAlign(CENTER, TOP);
  textSize(20);
  text(enemyHitPoints[index], position.x, position.y + size.y / 2);
}

void drawInfoArea() {
  noStroke();
  fill(255, 255, 255);
  rect(0, 0, width, infoAreaY);
}

// ENEMY FUNCTIONS
int findNextDeadEnemy() {
  for (int i = 0; i < maxEnemies; i++) {
    if (!enemyStates[i]) {
      return i;
    }
  }
  return -1;
}

int getTargetEnemy() {
  for (int i = 0; i < maxEnemies; i++) {
    if (!enemyStates[i]) { 
      continue; 
    }
    
    //int enemyType = enemies[i];
    //PVector enemySize = enemySizes[enemyType];
    //if (PVector.sub(enemyPositions[i], mousePos).mag() < enemySize) {
    //  return i;      
    //}
    if (checkCollision(enemyPositions[i], enemySizes[enemies[i]], mousePos, new PVector(5, 5))) {
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
  enemies[index] = enemyType;
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
    score += enemyScoreValues[enemies[index]];
  }
}

void moveEnemy(int index) {
  enemyPositions[index].add(enemyVelocities[index]);  
}

boolean checkCollision(PVector pos1, PVector size1, PVector pos2, PVector size2) {
  // if right x coord of rect 1 is less than the left x coord of rect 2 
  // or the left x coord of rect 1 is greater than the right x coord of rect 2
  if (pos1.x + size1.x / 2 < pos2.x - size2.x / 2 || pos1.x - size1.x / 2 > pos2.x + size2.x / 2) {
    return false; 
  }
  

  // if bottom y coord of rect 1 is less than the top y coord of rect 2
  // or the top y coord of rect 1 is greater than the bottom y coord of rect 2
  if (pos1.y + size1.y / 2 < pos2.y - size2.y / 2 || pos1.y - size1.y / 2 > pos2.y + size2.y / 2) {
    return false; 
  }
  
  return true;
}

void runEnemies() {
  for (int i = 0; i < maxEnemies; i++) {
    if (!enemyStates[i]) { 
      continue; 
    }
    moveEnemy(i);
    if (checkCollision(enemyPositions[i], enemySizes[enemies[i]], centerPos, spaceStationSize)) {
      killEnemy(i);
      damageSpaceStation(enemyDamageValues[enemies[i]]);
    }
    drawEnemy(i);
  }
}
