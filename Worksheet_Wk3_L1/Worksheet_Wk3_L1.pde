// Question 1
/*
8

12

i starts at 2, i = i - 1, i = i + 3
x  i < 10 result + i i-1 i+=3
2  true    5         1    4
4  true    9         3    6
6  true    13        5    8
8  true    23        7   10

23
*/
// Question 2
/*
for(int i = 2; i <= 14; i+= 2) {
  print(i + " ");  
}
println();
for(int i = 10; i >= -5; i--) {
  print(i + " ");
}
println();
for(int i = 1; i <= 1024; i*=2) {
  print(i + " ");
}
println();
for(int i = 0; i <= 2; i++) {
  for(int k = 1; k <= 5; k++) {
    print(i + " ");  
  }
}
println();
*/


// Question 3
/*
99

infinite

10

0

6

10

*/
// Question 4

void setup() {
  size(1000, 1000);
  strokeWeight(5);
  stroke(255, 0, 0);
  for(int i = 0; i < width; i += width / 10) {
    stroke(255, 0, 0);
    line(i, 0, i, i);
    stroke(0, 0, 255); 
    line(0, i, i, i);
  }


 /*
  size(2000, 600);
  final int rectCount = 100;
  int rectWidth = width / rectCount;
  int rectHeight = rectWidth;//height / 10;
  for(int i = 0; i < width - rectWidth / 2; i += rectWidth) {
    rect(i, height / 2 - rectHeight / 2, rectWidth, rectHeight);  
  }
  */
  /*
  size(800, 600);
  final int circleCount = 10;
  int diameter = width / circleCount;
  int radius = diameter / 2;
  for(int i = 0 + radius; i <= width - radius; i += diameter) {
    circle(i, height / 2, diameter);  
  }
  */
}

void draw() {
  
}



// Class Questions
/*
int x = 1;
while(x <= 64) {
  print(x + " ");
  x *= 2;
}
println();
int x2 = 7;
while(x2 <= 42) {
  print(x2 + " ");
  x2 += 7;
}
println();
int x3 = 1000000;
while(x3 >= 1) {
  print(x3 + " ");
  x3 /= 10;
}
println();
int x4 = 25;
while(x4 <= 150) {
  print(x4 + " ");
  x4 += 25;
}
println();
int x5 = 97;
while(x5 <= (char)'h') {
  print((char)x5 + " ");
  x5++;
}
println();
int x6 = 97;
while(x6 <= (char)'n') {
  print((char)x6 + " ");
  x6 += 2;
}
println();
for(int i = 1; i <= 64; i *= 2) {
  print(i + " ");  
}
println();
for(int i = 7; i <= 42; i += 7) {
  print(i + " ");
}
println();
for(int i= 1000000; i >= 1; i /= 10) {
  print(i + " ");
}
println();
for(int i = 25; i <= 150; i += 25) {
  print(i + " ");  
}
println();
for(int i = 97; i <= (char)'h'; i++) {
  print((char)i + " ");  
}
println();
int count = 0;
int sumValues = 0;
for(int i = -20; i <= 25; i++) {
  if(i % 5 == 0 && i % 4 == 0) {
    count++;
    sumValues += i;
  }
}
println(count);
println(sumValues);
*/
