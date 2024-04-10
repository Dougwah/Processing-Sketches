// GAME SETTINGS
int infoAreaY = 50;
int spaceStationDiameter = 50;
int maxEnemies = 10;

float crossHairX = 3.;
float crossHairY = 20.;
float xHairGap = 10.;
color xHairColor = color(255, 255, 255);

// ENEMY SETTINGS
int FRIGATE = 0;
int CRUISER = 1;
int DESTROYER = 2;
int CANNONPROJ = 3;
int[] enemyHealthValues = {1, 5, 3, 1};
int[] enemyDamageValues = {1, 2, 0, 3};
float[] enemySpeedValues = {1.5, 0.5, 1, 2};
int[] enemyScoreValues = {10, 20, 15, 30};
PVector[] enemySizes = {new PVector(25, 25)};

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
boolean gameStarted;
PVector mousePos;
PVector centerPos;
int currentMaxEnemies = 3;

int aliveEnemies = 0;
int[] enemyTypes = new int[maxEnemies];
PVector[] enemyPositions = new PVector[maxEnemies];
PVector[] enemyVelocities = new PVector[maxEnemies];
boolean[] enemyStates = new boolean[maxEnemies];
int[] enemyHitPoints = new int[maxEnemies];

void setup() {
  println(0%2);
  noCursor();
  size(800, 600);
  centerPos = new PVector(width / 2, height / 2);
  gameStarted = true;
}

void draw() {
  background(0);
  
  if (!gameStarted) {
    newGame();  
  }
  
  drawSpaceStation();
  
  if(aliveEnemies < currentMaxEnemies) {
    spawnEnemy(0);
    //spawnEnemy((int)random(4));  
  }
  
  for (int i = 0; i < enemyPositions.length; i++) {
    if (!enemyStates[i]) { 
      continue; 
    }
    moveEnemy(i);
    checkEnemyCollision(i);
    drawEnemy(i);
  }
  
  drawCrosshair();
  
  // GAME INFO AREA
  fill(255, 255, 255);
  rect(0, 0, width, infoAreaY);
  

}

// GAME FUNCTIONS
void newGame() {
  score = 0;
  millisPassed = 0;
  lastMilli = 0;
  aliveEnemies = 0;
  enemyStates = new boolean[maxEnemies];
  gameStarted = true;
}

PVector getCenter() {
  return new PVector(width / 2, height / 2);  
}

PVector getMousePos() {
  return new PVector(mouseX, max(mouseY, infoAreaY));
}

void drawCrosshair() {
  mousePos = getMousePos();
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
  circle(centerPos.x, centerPos.y, spaceStationDiameter);   
}

// ENEMY FUNCTIONS
int findNextDeadEnemy() {
  for (int i = 0; i < enemyStates.length; i++) {
    if (enemyStates[i] == false) {
      return i;
    }
  }
  return -1;
}

void moveEnemy(int index) {
  enemyPositions[index].add(enemyVelocities[index]);  
}

void drawEnemy(int index) {
  PVector position = enemyPositions[index];
  if (enemyTypes[index] == FRIGATE) {
    noStroke();
    fill(200, 200, 200);
    PVector size = enemySizes[FRIGATE];
    triangle(position.x - size.x, position.y - size.y / 2, position.x, position.y - size.y * 1.2, position.x + size.x, position.y - size.y / 2);
    triangle(position.x - size.x, position.y + size.y / 2, position.x, position.y + size.y * 1.2, position.x + size.x, position.y + size.y / 2);
    circle(position.x, position.y, size.x);
    fill(255 , 0, 0);
    circle(position.x, position.y, size.x / 2);
  }
}

void checkEnemyCollision(int index) {
  if (PVector.sub(enemyPositions[index], centerPos).mag() < spaceStationDiameter) {
    killEnemy(index);  
  }
}

void checkMouseCollision() {
  for (int i = 0; i < enemyPositions.length; i++) {
    
  }
}

void killEnemy(int index) {
  aliveEnemies--;
  enemyStates[index] = false;
}

void damageEnemy(int index, int damage) {
  enemyHitPoints[index] -= damage;
}

void spawnEnemy(int enemyType) {
  int index = findNextDeadEnemy();
  if (index == -1) { 
    return; 
  }
  
  PVector position;
  if (boolean((int)random(2))) {
    position = new PVector(random(width), max(infoAreaY, height * (int)random(2)));
  } else {
    position = new PVector(width * (int)random(2), random(infoAreaY, height));
  }
  
  PVector velocity = PVector.sub(centerPos, position);
  
  aliveEnemies++;
  enemyTypes[index] = enemyType;
  enemyStates[index] = true;
  enemyHitPoints[index] = enemyHealthValues[enemyType];
  enemyPositions[index] = position;
  enemyVelocities[index] = velocity.setMag(enemySpeedValues[enemyType]);
}
