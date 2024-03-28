import processing.sound.*;

int WEAPONFIRE = 1;
int SHIPDEATH = 2;
int SHIPDAMAGE = 3;
int ASTEROIDDEATH = 4;
int PICKUP = 5;

String[] soundTypes = new String[]{"weaponFire", "shipDeath", "shipDamage", "asteroidDeath", "pickup"};
int[] soundCount = new int[]{1, 3, 3, 3, 1};
ArrayList<ArrayList> sounds = new ArrayList<ArrayList>();

PFont willowFont;
PFont marineFont;

ObjectHandler objHandler;
Round round;

void setup() {
  //fullScreen();
  size(2560, 1440);
  frameRate(60);

  willowFont = createFont("WillowBody.ttf", 128);
  marineFont = createFont("SpaceMarine.ttf", 128);
  
  Sound.volume(0.1);
  for (int i = 0; i < soundTypes.length; i++) {
    ArrayList<SoundFile> soundList = new ArrayList<SoundFile>();
    
    for (int i2 = 0; i2 < soundCount[i]; i2++) {
      soundList.add(new SoundFile(this, "data/sounds/" + soundTypes[i] + "/" + (i2 + 1) + ".ogg"));
    }
    
   sounds.add(soundList);
   
  }

  round = new Round(difficultyScaleRate);
}

void draw() {
  background(0);
  noStroke();
  round.run();
}

void playSound(int soundType) {
  ArrayList<SoundFile> soundList = sounds.get(soundType - 1);
  SoundFile sound = soundList.get(floor(random(soundList.size())));
  sound.play();
}

float NormalizeFrames(float x) {
  return x * (238 / frameRate);
}

// add main menu allowing difficulty selection
// each difficulty will have the applied game values stored and displayed to the player

// add pickups that increase weapon stats
// save scores to file and have leaderboard

// add option to toggle wrap around edges

// add sprite damage states to asteroids

// add a game over screen
