// ===== GAME SETTINGS =====

// Player
float toolRange = 200;
float toolPower = 1000;
int playerSize = 100;
// Tools
String[] toolNames = {
  "Hands",
  "Small Rake",
  "Large Rake"
};

int[] toolRanges = {
  30,
  60,
  100
};

int[] toolPowers = {
  1000,
  1400,
  2000
};

// Upgrades
String[] upgradeNames = {
  "Leaf Cap ++",
  "Basic Leaf Value ++",
};

int[] upgradeMaxLevels = {30, 100};
int[] upgradeBaseCost = {5, 10};
int[] upgradeCostType = {0, 0};
float[] upgradeCostExponent = {1.1, 1.5};
int[] upgradeBaseEffect = {1, 2};

// Leaves
int maxLeaves = 200;
String[] leafNames = {
  "Basic Leaf",
  "Gold Leaf"
};

color[] leafColors = {
  color(50, 160, 80),
  color(255, 170, 50),
};

PVector[] leafSizes = {
  new PVector(40, 40),
  new PVector(35, 35),
};

float[] leafFriction = {
  0.05,
  0.1,
};

float[] leafSpawnChances = {
  100,
  5,
};

PImage[] leafImages = new PImage[leafNames.length];

// ===== GAME VALUES =====

// Player
Leaf[] leaves = new Leaf[maxLeaves];
Player ply;

// Leaves
int[] leafMaxCounts = {10, 0};
int currentMaxLeaves = 10;
int[] leafRewards = {1, 1};

// ===== PROCESSING FUNCTIONS =====

void setup() {
  size(1500, 1000);
  ply = new Player();
  for(int i = 0; i < maxLeaves; i++) {
    leaves[i] = new Leaf();  
  }
}

void draw() {
  background(0, 180, 50);
  ply.run();
  runLeaves();
  drawHudInfo();
}

void mousePressed() {
  ply.buyUpgrade(1);
}

// ===== GAME FUNCTIONS =====

void runLeaves() {
  for(int i = 0; i < getMaxLeaves(); i++) {
    Leaf l = leaves[i];
    PVector vel = PVector.sub(l.pos, new PVector(mouseX, mouseY));
    if(vel.mag() < toolRanges[ply.getTool()] + playerSize / 2) {
      l.addVel(vel.setMag(1 / (vel.mag() + playerSize / 2) * toolPowers[ply.getTool()]));
    }
    l.run();
  }
}

int getMaxLeaves() {
  return currentMaxLeaves + ply.getUpgradeLevel(0);
}

void drawHudInfo() {
    for(int i = 0; i < leafNames.length; i++) {
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(leafNames[i] + ": " + ply.getLeaves(i),width * 0.01, height * 0.1 + i * 20);
  }
}
