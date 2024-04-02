PVector segmentSize = new PVector(20 , 20);
PVector headPosition;
ArrayList<PVector> positions = new ArrayList<PVector>();
PVector currentDirection = new PVector(1, 0);
int playerSize = 1;
String keys = "wasd";
char lastKey;
int[] xMovement = {0, -1, 0, 1};
int[] yMovement = {-1, 0, 1, 0};
int lastTick = millis();

void setup() {
  headPosition = new PVector(width / 2, height / 2);
  size(1920, 1080);
}

void draw() {
  background(0);
  if (keyPressed) {
    if (key == 'l') { playerSize += 1; }
    int keyIndex = keys.indexOf(key);
    if (keyIndex != -1) {
      currentDirection.set(new PVector(xMovement[keyIndex], yMovement[keyIndex]));
      lastKey = key;
    }
  }
  
  if (millis() > lastTick + 200) {
    headPosition.add(currentDirection.setMag(20));
    positions.add(headPosition);
    lastTick = millis();
 
  }
  
  for (int i = 0; i < positions.size() - 1; i++) {
    PVector position = positions.get(i);
    rect(position.x, position.y, segmentSize.x, segmentSize.y);
  }

}
