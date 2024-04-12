//1 = 1.2
//2 = 1.8
//3 = 1, 3, 0
//4 = 74 to 65 inclusive
//5
/*
int data = 50;
int result = (int)sqrt((data*data));
println(result);
*/
//6
/*
int result;
int a = 0;
int b = 1;
int c = 0;
if (a > 0 && b > 0 && c > 0) {
  result = 1;  
} else if ( a < 1 && b < 1 && c < 1) {
  result = -1;  
} else {
  result = 0;
}
println(result);
*/
//7
/*
boolean result;
if (a % 2 == 0 && b % 2 == 0 && c % 2 == 0) {
  result = true;
} else {
  result = false; 
}
println(result);
*/
//8
/*
int clicks = 0;
void setup() {
  size(500, 500);
}

void draw() {
  
}

void mousePressed() {
  int colorState = clicks % 3;
  if (colorState == 0) {
    fill(255, 0, 0); 
  } else if (colorState == 1) {
    fill(0, 255, 0);  
  } else if (colorState == 2) {
    fill(0, 0, 255); 
  }
  clicks++;
  circle(mouseX, mouseY, 50);  
}
*/
//9
/*
String text;
void setup() {
  size(400, 400);
  text = "Hello!";
}

void draw() {
  background(0);
  textAlign(CENTER, CENTER);
  textSize(32);
  text(text, width / 2, height / 2);
}

void mousePressed() {
  text = "Welcome to WCOM1000";  
}
*/
//10
/*
int circle1PosX;
int circle1PosY;
void setup() {
  size(200, 200);
  circle1PosX = width / 2;
  circle1PosY = height / 2;
}

void draw() {
  background(0);
  int circle2PosX = mouseX;
  int circle2PosY = mouseY;
  
  int distanceX = abs(circle2PosX - circle1PosX);
  int distanceY = abs(circle2PosY - circle1PosY);
  
  float distance = sqrt(pow(distanceX, 2) + pow(distanceY, 2));
  if (distance < 60) {
    fill(255, 0, 0);
  } else {
    fill(255);  
  }
  
  circle(circle1PosX, circle1PosY, 60);
  circle(circle2PosX, circle2PosY, 60);
}
*/
//11
/*
PVector circlePos;
boolean bGState = true;
void setup() {
  size(1200, 800);
  circlePos = new PVector(width / 2, height / 2);
}

void draw() {
  background(0);
  strokeWeight(5);
  if (bGState) {
    stroke(0, 255, 0);
    line(width / 2, 0, width / 2, height);
    line(0, height / 2, width, height / 2);
    fill(255, 0, 0);
  } else {
    stroke(255, 0, 0);
    line(0, 0, width, height);
    line(0, height, width, 0);
    fill(0, 0, 255);
  }
  noStroke();
  circle(circlePos.x, circlePos.y, 30);
  circlePos.x += 1;
}

void mousePressed() {
  bGState = !bGState;
}
*/
