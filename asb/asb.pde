
void setup() {
  size(1000, 1000);
}

void draw() {
  
}

void mousePressed() {
  if (mouseX < width / 4 && mouseY < height / 2) {
    fill(0);
    circle(mouseX, mouseY, 30);  
  } else if (mouseX < width / 3 && mouseX > width / 2) {
    fill(0, 0, 255);
    square(mouseX - 30, mouseY - 30, 30);
  }
}
