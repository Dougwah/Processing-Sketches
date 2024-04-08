Proj[] projectiles;
int projCount = 1000;

void setup() {
  frameRate(238);
  size(1000, 1000);
  projectiles = new Proj[projCount];
  for(int i = 0; i < projCount; i++) {
    PVector vector = new PVector(random(-1, 1), random(-1, 1)).setMag(5);
    Proj p = new Proj(new PVector(width / 2, height / 2), vector);
    projectiles[i] = p;
  }
}

void draw() {
  background(255);
  for (int i = projectiles.length - 1; i >= 0; i--) {
    projectiles[i].run();
  }
}
