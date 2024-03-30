import processing.sound.*;

int WEAPONFIRE = 0;
int SHIPDEATH = 1;
int SHIPDAMAGE = 2;
int ASTEROIDDEATH = 3;
int PICKUP = 4;
int MUSIC = 5;
int SHIPHEAL = 6;
int SHIPHEALTHFULL = 7;
int SHIPBLOCKDAMAGE = 8;

String[] soundTypes = new String[]{"weaponFire", "shipDeath", "shipDamage", "asteroidDeath", "pickup", "music", "shipHeal", "shipHealthFull", "shipBlockDamage"};
int[] soundCount = new int[]{1, 3, 3, 3, 1, 1, 1, 1, 1};
ArrayList<ArrayList> sounds = new ArrayList<ArrayList>();

PFont willowFont;
PFont marineFont;

ObjectHandler objHandler;
Round round;
Background bg;

boolean[] keys = new boolean[525];
boolean gameStarted = false;

void setup() {
  fullScreen();
  size(displayWidth, displayHeight);
  frameRate(60);
  
  bg = new Background();
  
  willowFont = createFont("WillowBody.ttf", 128);
  marineFont = createFont("SpaceMarine.ttf", 128);
  
  Sound.volume(0.1);
  for (int i = 0; i < soundTypes.length; i++) {
    ArrayList<SoundFile> soundList = new ArrayList<SoundFile>();
    
    for (int i2 = 0; i2 < soundCount[i]; i2++) {
      soundList.add(new SoundFile(this, "data/sounds/" + soundTypes[i] + "/" + (i2 + 1) + ".wav"));
    }
    
   sounds.add(soundList);
  }
  
  playSound(MUSIC);
  round = new Round(difficultyScaleRate);
}

void keyPressed() {
  keys[keyCode] = true;
};

void keyReleased() {
  keys[keyCode] = false;
};

void draw() {
  background(0);
  noStroke();
  bg.run();
  if (gameStarted == false) {
    
     if (keys[89]) {
       gameStarted = true;
     }
     
     if (keys[78]) {
       exit();
     }
    
    pushMatrix();
      fill(0, 255, 0);
      textFont(marineFont);
      textAlign(CENTER, CENTER);
      textSize(50);
      textSize(128);
      text("ASTEROID GAME", width * 0.5, height / 2.5);
      textFont(willowFont);
      textSize(50);
      text("Start? [Y/N]", width * 0.5, height / 1.5);
      textSize(25);
      textAlign(LEFT, CENTER);
      text("Move: W, A, S, D\nRotate: < > / N, M\nShoot: SPACE\nQuit: ESC", width * 0.05, height * 0.9);
    popMatrix();
    return;
  }
  round.run();
}

void playSound(int soundType) {
  ArrayList<SoundFile> soundList = sounds.get(soundType);
  SoundFile sound = soundList.get(floor(random(soundList.size())));
  sound.play();
}

float nFrames(float x) {
  return x * (238 / frameRate);
}

float nX(float x) {
  return (displayWidth / 2560) * x;
}

float nY(float y) {
  return (displayHeight / 1440) * y; 
}

PVector nVector(PVector vector) {
  vector.x = nX(vector.x);
  vector.y = nY(vector.y);
  println(vector.x, vector.y);
  return vector;
}

String formatMillis(int millis) {
  int seconds = millis / 1000;
  return nf(floor(seconds / 60), 2, 0) + " : " + nf((seconds % 60), 2, 0) + " : " + nf((millis) % 1000, 3, 0); 
}

// add main menu allowing difficulty selection
// each difficulty will have the applied game values stored and displayed to the player
// save scores to file and have leaderboard
// add sprite damage states to asteroids
