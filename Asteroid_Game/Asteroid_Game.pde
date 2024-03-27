import processing.sound.*;

int WEAPONFIRE = 1;
int SHIPDEATH = 2;
int SHIPDAMAGE = 3;
int ASTEROIDDEATH = 4;

String[] soundTypes = new String[]{"weaponFire", "shipDeath", "shipDamage", "asteroidDeath"};
int[] soundCount = new int[]{1, 3, 3, 3};
ArrayList<ArrayList> sounds = new ArrayList<ArrayList>();

PFont willowFont;
PFont marineFont;

Round round;

void setup() {
  //fullScreen();
  size(1920, 1080);
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
  ArrayList<SoundFile> _sounds = sounds.get(soundType - 1);
  SoundFile sound = _sounds.get(floor(random(0, _sounds.size())));
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

// add object arrays to class and have a static get function to retrieve
// add a function that loops through the objects and removes them to be called when a new round is made
// pass coordinates to the class for collision to avoid requiring a reference to the player?
