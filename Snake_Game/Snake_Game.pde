int gridSize = 40;
int boardSize = 400;
int gameInterval = 200;
char lastKey = ' ';
boolean inProgress = false;
Pickup pickup;
Snake snake;

void settings() {
  size(boardSize, boardSize);
}

void draw() {
  background(#24A502);
  if (!inProgress) {
    newGame();
  }
  
  snake.run();
  pickup.run();
  
  if (!snake.alive) {
    inProgress = false;
  }

  if (snake.alive == false) {
    fill(255, 0, 0);
    rect(0, 0, width, height);
    return;
  }
}

void keyPressed() {
  println(key);
  lastKey = key;
}

void newGame() {
  println("New Game");
  inProgress = true;
  snake = new Snake(new PVector(width / 2, height / 2), 1);
  pickup = new Pickup();
}

int getGridCount() {
  int count = int(pow(floor(boardSize / gridSize), 2));
  return count; 
}
