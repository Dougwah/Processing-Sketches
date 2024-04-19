// float / int = float
// int / float = float
// int / int = int
// (float) int = int.0

/*
DIVIDING A FLOAT BY AN INTEGER = FLOAT
2.0 / 2 = 1.0 = 1.0

DIVIDING AN INTEGER BY A FLOAT = FLOAT
2 / 1.5 = 1.3

DIVING AN INTEGER BY AN INTEGER = INTEGER
16 / 5 = 3

CASTING INTEGER DIVISION TO FLOAT = INTEGER DIVISION.0
int 11, 3
float c = a / b = 9.0
*/

/*
int diameter;
int radius;
PVector[] circlePositions;

void setup() {
  size(1000, 1000);
  diameter = width / 50;
  radius = diameter / 2;
  for(int i = 0 + radius; i < width; i+=diameter) {
    for(int k = 0 + radius; k < height; k += diameter) { 
      circle(i, k, diameter);
    }
  }
  for(int i = 1; i <= 6; i++) {
    for(int k = 1; k <= i; k++) {
      print(i + " ");  
    }
  }
  
  println();
  for(int i = 1; i <= 3; i++) {
    for(int k = 1; k <= 5; k++) {
      print("# ");    
    }
    println();
  }
  
  println();
  for(int i = 1; i <= 6; i++) {
    for(int k = 1; k <= 7 - i; k++) {
      print(i + " ");  
    }
  }
  
  println();
  for(int i = 1; i <= 6; i++) {
    for(int k = 1; k <= i; k++) {
      print(k + " ");    
    }
  }
  
  println();
  for(int i = 1; i <= 15; i++) {
    print("# ");
    if(i % 5 == 0) {
      println();
    }
  }
  
  println();
  for(int i = 1; i <= 5; i++) {
    for(int k = 1; k <= i; k++) {
      print("# ");    
    }
    println();
  }
  
  println();
  for(int i = 1; i <= 6; i++) {
    for(int k = 1; k <= i; k++) {
      print(i + " ");    
    }
    println();
  }
  
  println();
  for(int i = 1; i <= 5; i++) {
    for(int k = i; k <= 6; k++) {
      print(k * 10 + " ");    
    }
    println();
  }
  
}

void draw() {

}
// CHECKERBOARD
*/
/*
int tileWidth;
int halfTileWidth;
PVector[] circlePositions;
int currentTile = 0;
void setup() {
  noStroke();
  size(1000, 1000);
  
  tileWidth = width / 8;
  halfTileWidth = tileWidth / 2;
  for(int i = halfTileWidth; i < width; i+= tileWidth) {
    for(int k = halfTileWidth; k < height; k += tileWidth) {
      if(currentTile % 2 != 0) {
        fill(118, 145, 84);
      } else {
        fill(233, 233, 206);  
      }
      currentTile++;
      square(i - halfTileWidth, k - halfTileWidth, tileWidth);
    }
    currentTile++;
  }
}
*/

// CIRCLE PYRAMIDS
/*
int diameter;
int radius;
PVector[] circlePositions;

void setup() {
  noStroke();
  size(1000, 1000);
  diameter = width / 50;
  radius = diameter / 2;
  // TOP LEFT CORNER

  for(int i = 0 + radius; i < width; i+= diameter) {
    for(int k = 0 + radius; k <= height - i; k += diameter) { 
      fill(255 ,0 ,0);
      circle(i, k, diameter);
    }
  }

  // TOP RIGHT CORNER

  for(int i = 0 + radius; i < width; i+= diameter) {
    for(int k = 0 + radius; k <= - i; k += diameter) { 
      fill(0 ,255 ,0);
      circle(i, k, diameter);
    }
  }

  // BOTTOM LEFT CORNER

  for(int i = 0 + radius; i < width; i+= diameter) {
    for(int k = height - radius; k >= 0 + i; k -= diameter) { 
      fill(0 ,0 ,255); 
      circle(i, k, diameter);
    }
  }

  // BOTTOM RIGHT CORNER
  for(int i = 0 + radius; i < width; i+= diameter) {
    for(int k = height - radius; k >= width -  i; k -= diameter) { 
      fill(0 ,255 ,0); 
      circle(i, k, diameter);
    }
  }
}
*/
/*
// 4 COLOUR GRID
int diameter;
int radius;
PVector[] circlePositions;

void setup() {
  noStroke();
  size(1000, 1000);
  diameter = width / 300;
  radius = diameter / 2;
  
  // LEFT
  for(int i = radius; i < width / 2; i+= diameter) {
    for(int k = i; k <= height - i; k += diameter) { 
      fill(255 ,0 ,0);
      circle(i, k, diameter);
    }
  }
  // RIGHT
  for(int i = radius; i < width; i+= diameter) {
    for(int k = height - i; k <= i; k += diameter) { 
      fill(0 ,255 ,0);
      circle(i, k, diameter);
    }
  }  
  // TOP
  for(int i = radius; i < width / 2; i+= diameter) {
    for(int k = i; k <= height - i; k += diameter) { 
      fill(0 ,0 ,255);
      circle(k, i, diameter);
    }
  }
  // BOTTOM
  for(int i = radius; i < width; i+= diameter) {
    for(int k = height - i; k <= i; k += diameter) { 
      fill(0 ,255 ,255);
      circle(k, i, diameter);
    }
  }
}
*/
// DIGIT FUNCTIONS
/*
void setup() {
  println("Digit Sum of 1729: " + sumDigits(1729));
  println("Digit Count of 1729: " + countDigits(1729));
  println("Highest Digit of 1729: " + getHighestDigit(1729));
  println("Odd Digit Count of 1729: " + countOddDigits(1729));
  println("Odd Digit Count of 222: " + countOddDigits(222));
  println("Odd Digit Count of 110: " + countOddDigits(110));
}

int countDigits(int n) {
  int result = 0;
  for(int i = n; i > 0; i /= 10) {
    result ++;
  }
  return result;
}

int sumDigits(int n) {
  int result = 0;
  for(int i = n; i > 0; i /= 10) {
    result += i % 10;
  }
  return result;
}

int getHighestDigit(int n) {
  int result = 0;
  for(int i = n; i > 0; i /=10) {
    int digit = i % 10;
    result = max(digit, result);
  }
  return result;
}

int countOddDigits(int n) {
  int result = 0;
  for(int i = n; i > 0; i /= 10) {
   if(i % 10 % 2 != 0) {
     result++;
    }
  }
  return result;
}
*/
//WK2 L5 
//SLIDE 13
/*
for(int i = 2; i <= 50; i+=3) {
  print(i + " ");  
}
println();
for(int i = 100; i >= 20; i-=5) {
  print(i + " ");  
}
println();
for(int i = 1; i <= 8192; i*=2) {
  print(i + " ");  
}
println();
for(int i = 7; i <= 147; i+=7) {
  print(i + " ");  
}
*/
//SLIDE 14
/*
void setup() {
  size(200, 200);
  int radius = 25;
  for(int i = radius; i <= 200 - radius; i += radius*2) {
    circle(i, i, radius * 2);  
  }
}
*/
//SLIDE 15

void setup() {
  size(200, 200);
  int radius = 20;
  for(int i = radius; i <= 200 - radius; i += radius * 2) {
    for(int k = height / 3 - radius; k <= height - height / 3 + radius; k+= radius * 2) {
      circle(i, k, radius * 2);  
    }
  }
}

// SLIDE 16
/*
void setup() {
  size(200, 200);
  int diameter = 20;
  int radius = diameter / 2;
  for(int i = radius; i <= width; i+= diameter) {
    for(int k = radius; k <= i; k+= diameter) {
      circle(i, k, diameter);  
    }
  }
}
*/
