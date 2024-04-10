//Task 1
/*
11 > 9 - 1
11 > 8 = true

!(1==1)
!true = false

(6 >= 4) && (3 == 3)
true && true = true

true || false = true

(-5 < 5) || false
true || false = true

false && ((9 != 9) || true)
false && (false || true) = false

!((!true || !false) && (!false && true))
!((false || true) && (true && true))
!(true && true)
!true = false

x < 5 && x > 10 = false

true || false || false || false = true

true && true && false && true && true && true || false
true && false && true && true && true || false
false && true && true && true || false
false && true && true || false
false && true || false
false || false = false
*/

//Task 3
/*
int num = 20
num = 40
num = 40 + 10 = 50
num = 50
*/

//Task 4
/*
result = 7
result = 7 -3 = 4
result = 4 * 3 = 12
result = 12 + 1 = 13
*/

//Task 5
/*
if (a < 1) { 
  b = b + 1; 
  if (b != 2) { 
    if (b > 3) { 
      if (d == 4) { 
        c = c + 1; 
      } else {
        if (c == 3) {
          c = c - 1; 
        } else {
          c = a;
        }
      }
    }
  }
} else {
  b = 3;
}

//a
a = 0
b = (5 + 1)
c = (3 - 1)
d = 3

//b
a = 1
b = (5 - 3)
c = 2
d = 2
*/

//TASK 6
/*

if (value % 5 == 0) {
  result = true;  
} else {
  result =false;
}

if (value % 5 == 0 || value % 7 == 0) {
  return true  
} else {
  return false
}

if (value % 5 == 0 && value % 7 == 0) {
  return true  
} else {
  return false
}
*/

//Task 7
int circleX = width / 2;
int circleY = height / 2;
void setup() {
  size(1000, 1000);
}

void draw() {
  background(255);
  noStroke();
  if (circleY < height / 2) {
    fill(0, 0, 0);
  } else {
    fill(255, 0, 0);  
  }
  circle(circleX, circleY, 100);
  circle(circleX - 50, circleY - 50, 80);
  circle(circleX + 50, circleY - 50, 80);
  circleY += 10;
}

void mousePressed() {
  circleX = mouseX;
  circleY = mouseY;
}
