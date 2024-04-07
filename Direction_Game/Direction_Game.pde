int lastKey;
int lastDirection;
boolean keyMatch;
String[] directions = {"Up", "Down", "Left", "Right"};

int UP = 0;
int DOWN = 1;
int LEFT = 2;
int RIGHT = 3;

void setup () {
  size(1000, 1000);
  random(3);
  lastKey = -1;
  lastDirection = -1;
  keyMatch = false;
}

void draw() {
  background(0);
  checkDirection();
  if (keyMatch == true) {
    pickDirection();
  }

  textSize(100);
  textAlign(2, 2);
  text(directions[lastDirection], 500, 500);
}

void keyPressed() {
  switch(key) {
    case('w'):
      lastKey = 0;
      break;
    case('s'):
      lastKey = 1;
      break;
    case('a'):
      lastKey = 2;
      break;
    case('d'):
      lastKey = 3;
      break;
  }
}

void pickDirection() {
  lastDirection = floor(random(4));
  println(lastDirection);
}

void checkDirection() {
  if (lastKey == lastDirection) {
    lastKey = -1;
    keyMatch = true;
  } else {
    keyMatch = false;;
}
