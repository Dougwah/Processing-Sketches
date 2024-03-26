boolean[] keys = new boolean[256];
Player ply;
Weapon plyWep;

void keyPressed() {
  keys[keyCode] = true;
};

void keyReleased() {
  keys[keyCode] = false;
};

void setup() {
  size(1920, 1080);
  frameRate(238);
  ply = new Player(width / 2, height / 2);
  plyWep = new Weapon(1, 5, 1, 5);
  ply.SetWeapon(plyWep);
}

void draw() {
  background(0);
  ply.Run();
  ply.Wep.DrawBullets();
}

float NormalizeFrames(float x) {
  return x * (238 / frameRate);
}
