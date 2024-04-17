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
*/
int tileWidth;
int halfTileWidth;
PVector[] circlePositions;
void setup() {
  size(1000, 1000);
  tileWidth = width / 50;
  halfTileWidth = tileWidth / 2;
  for(int i = halfTileWidth; i < width; i+= tileWidth) {
    for(int k = halfTileWidth; k < height; k += tileWidth) { 
      square(i - halfTileWidth, k - halfTileWidth, tileWidth);
    }
  }
}
