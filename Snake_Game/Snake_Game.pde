int segmentSize = 30;
Pickup pickup;
Snake snake;

void setup() {
  size(1920, 1080);
  snake = new Snake(new PVector(width / 2, height / 2), 10);
  pickup = new Pickup();
}

void draw() {
  background(#24A502);
  snake.run();
  pickup.run();
  
  if (snake.alive == false) {
    fill(255, 0, 0);
    rect(0, 0, width, height);
    return;
  }
}
