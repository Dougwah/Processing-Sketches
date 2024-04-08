// TASK 1
/*
5 + 7 * 2
5 + 14
19

5 * 7 + 2
35 + 2
37

3 * 14 / 4
*/

//TASK 2
/*
size(300, 300);
background(255);
fill(200, 200, 200);
noStroke();
circle(60, 150, 100);
circle(240, 150, 100);
stroke(1);
noFill();
ellipse(150, 150, 150, 280);
fill(80, 80, 80);
square(60, 60, 180);
fill(50, 50, 50);
circle(150, 150, 180);
*/
// TASK 3
/*
int diameter;

void setup() {
  size(300, 300);
  diameter = 180;
}

void draw() {
  background(255);
  fill(200, 200, 200);
  noStroke();
  circle(60, 150, 100);
  circle(240, 150, 100);
  stroke(1);
  noFill();
  ellipse(150, 150, 150, 280);
  fill(80, 80, 80);
  square(60, 60, 180);
  fill(50, 50, 50);
  circle(150, 150, diameter);
  diameter = max(diameter - 1, 0);
}
*/
//TASK 4
void setup() {
  background(255);
  size(1000, 1000);
}

void draw() {

}

void mousePressed() {
  noStroke();
  fill(255, 0, 0);
  circle(mouseX, mouseY, 40);
}


//TASK 5
/*
PVector position;

void setup() {
  size(1000, 1000);
  position = new PVector(-width, -height);
}

void draw() {
  background(255);
  noStroke();
  fill(255, 0, 0);
  circle(position.x, position.y, 40);
  position.y += 1;
}

void mousePressed() {
  position = new PVector(mouseX, mouseY);
}
*/
