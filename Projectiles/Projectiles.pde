//ArrayList<Proj> projectiles = new ArrayList<Proj>();

Proj[] projectiles;
int projCount = 1000;

void setup() {
  size(1000, 1000);
  projectiles = new Proj[projCount];
  for(int i = 0; i < projCount; i++) {
    PVector velocity = new PVector(random(0, 15), random(0, 15));
    if (boolean((int)random(2))) {
      velocity.mult(-1);  
    }
    println(velocity);
    Proj p = new Proj(new PVector(width / 2, height / 2), velocity);
    projectiles[i] = p;
  }
}

void draw() {
  background(255);
  for (int i = projectiles.length - 1; i >= 0; i--) {
    projectiles[i].run();
  }
}
