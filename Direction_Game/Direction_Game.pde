int lastKey;
boolean keyMatch;
PVector arrowSize = new PVector(100., 200.);
String[] directionStrings = {"Up", "Down", "Left", "Right"};
int[] directions = new int[1];

int UP = 0;
int DOWN = 1;
int LEFT = 2;
int RIGHT = 3;

void setup () {
  size(1000, 1000);
  random(3);
  lastKey = -1;
  keyMatch = false;
}

void draw() {
  background(0);
  drawArrow(100);
  checkDirection();
  if (keyMatch == true) {
    setDirection();
  }

  textSize(100);
  textAlign(CENTER, CENTER);
  text(directionStrings[getDirection()], 500, 500);
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

void setDirection() {
  directions = append(directions, floor(random(4)));
  println(directions);
  
}

void drawArrow(int angle) {
  PVector origin = new PVector(width / 2, height / 2);
  beginShape();
    vertex(origin.x, origin.y);
    vertex(origin.x + arrowSize.x / 2, origin.y + arrowSize.y / 4);
    vertex(origin.x + arrowSize.x / 2, origin.y + arrowSize.y / 3);
    vertex(origin.x + arrowSize.x / 4, origin.y + arrowSize.y / 3);
    vertex(origin.x + arrowSize.x / 4, origin.y + arrowSize.y);
    vertex(origin.x - arrowSize.x / 4, origin.y + arrowSize.y);
    vertex(origin.x + arrowSize.x / 4, origin.y + arrowSize.y / 3);    
  endShape();
}

int getDirection () {
  return(directions[directions.length - 1]);    
}

void checkDirection() {
  if (lastKey == getDirection()) {
    lastKey = -1;
    keyMatch = true;
  } else {
    keyMatch = false;
  }
}
