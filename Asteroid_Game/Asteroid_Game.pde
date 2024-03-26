
Player ply;
Weapon plyWep;

void setup() {
  size(1920, 1080);
  frameRate(238);
  ply = new Player(new PVector(width / 2, height / 2));
  plyWep = new Weapon(1, 5, new PVector(20, 20), 0.1);
  ply.setWeapon(plyWep);
}

void draw() {
  background(0);
  ply.run();
  
  for (int i = Projectiles.size() - 1; i >= 0; i--) {
    Projectile p = Projectiles.get(i);
    if (p.destroyed == true) {
      Projectiles.remove(p);
      continue;
    }
    p.run();
  }
  
}

float NormalizeFrames(float x) {
  return x * (238 / frameRate);
}
