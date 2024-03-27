import processing.sound.*;

boolean gameOver = false;
ArrayList<SoundFile> weaponSounds = new ArrayList<SoundFile>();
ArrayList<SoundFile> shipDeathSounds = new ArrayList<SoundFile>();
ArrayList<SoundFile> shipDamageSounds = new ArrayList<SoundFile>();
ArrayList<SoundFile> asteroidSounds = new ArrayList<SoundFile>();


Player ply;
Weapon plyWep;

void setup() {
  size(1920, 1080);
  frameRate(60);

  ply = new Player(new PVector(width / 2, height / 2));
  plyWep = new Weapon(5, 30, new PVector(10, 40), 0.6);
  ply.setWeapon(plyWep);
  
  Sound.volume(0.1);
  for (int i = 0; i < 3; i++) {
    weaponSounds.add(new SoundFile(this, "sounds/weapon/"+ (i + 1) + ".ogg"));
    shipDeathSounds.add(new SoundFile(this, "sounds/shipDeath/"+ (i + 1) + ".ogg"));
    shipDamageSounds.add(new SoundFile(this, "sounds/shipDamage/"+ (i + 1) + ".ogg"));
    asteroidSounds.add(new SoundFile(this, "sounds/asteroid/"+ (i + 1) + ".ogg"));
  }

  initAsteroids();
}

void draw() {
  if (gameOver == true) { 
    rectMode(CORNER);
    fill(0, 0, 255);
    rect(0, 0, width, height);
    return; 
  }
  

  
  background(0);
  noStroke();
  ply.run();
  
  runAsteroids();
  runBullets();
}


void endGame() {
  gameOver = true;
}

float NormalizeFrames(float x) {
  return x * (238 / frameRate);
}
