void setup() {
  size(1000, 500);
  background(255);
  line(width * 0.5, 0, width * 0.5, height);
  line(width * 0.25, 0, width * 0.25, height);
  line(width * 0.75, 0, width * 0.75, height);
  
  line(0, height * 0.5, width, height * 0.5);
}

void draw() {

}

void mousePressed() {
  if (mouseY < height * 0.5) {
    
    if (mouseX < width * 0.25) {
      fill(0);
      circle(mouseX, mouseY, 30);
    } else if (mouseX > width * 0.5 && mouseX < width * 0.75) {
      fill(0, 0, 255);
      square(mouseX - 15, mouseY - 15, 30);   
    }
  
  } else {
    
    if (mouseX > width * 0.5 && mouseX < width * 0.75) {
      fill(255, 0, 0);
      triangle(mouseX - 15, mouseY + 15, mouseX, mouseY - 15, mouseX + 15, mouseY + 15);   
    } else if (mouseX > width * 0.75) {
       fill(0, 255, 0);
       circle(mouseX, mouseY, 30);   
    }
    
  }
}
