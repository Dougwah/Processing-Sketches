int[] xPositons;
int squareCount = 1000;
int[] yPositions = new int[squareCount];
int[] xPositions = new int[squareCount];
int[] sizes = new int[squareCount];

void setup() {
  size(1000, 1000);
  
  generateNonOverlappingSquares(0, 0, 1000, 1000, 6, 100, squareCount, 1000);
  
  println(factorial(5));
  println(sum(10));
  println(sumOdd(2));
  println(sumEven(3));
  println(collatz(27));
  println(countDigits(100));
  println(sumDigits(1234));
  println(sumEvenDigits(1234));
  println(sumRange(1, 6));
  println(multiply(-100, 6));
  println(divide(200, 3));
  
  println(filterArray(new String[] {"aaab", "hfsh", "krbnmshn", "iypemsf"}, "s"));
}

String[] filterArray(String[] arr, String filter) {
 String[] temp = new String[arr.length];
 int count = 0;
 for(int i = 0; i < arr.length; i++) {
   if(arr[i].indexOf(filter) != -1) {
     temp[count] = arr[i];
     count++;
   }
 }
 
 String[] result = new String[count];
 for(int i = 0; i < count; i++) {
   result[i] = temp[i];
 }
 
 return result;
}

int sum(int n) {
  if(n == 0) {
    return n;
  }
  
  return n + sum(n - 1);
}

int sumOdd(int n) {
  if(n <= 0) {
    return n;
  }
 
  return n * 2 - 1 + sumOdd(n - 1);
}

int sumEven(int n) {
  if(n <= 0) {
    return n;
  }
 
  return n * 2 + sumEven(n - 1);
}

int factorial(int x) {
  if(x == 1) {
    return x;  
  }
  
  return x * factorial(x - 1);
}

int collatz(int n) {
  if(n == 1) {
    return 0;
  }
  
  if(n % 2 == 0) {
    return 1 + collatz(n / 2);
  }
  
  
  return 1 + collatz(n * 3 + 1);
}

int countDigits(int n) {
 if(n == 0) {
   return 0;
 }
 
 return 1 + countDigits(n / 10);
 
}

int sumDigits(int n) {
 if(n == 0) {
   return 0;
 }
 
  return n % 10 + sumDigits(n / 10);
}

int sumEvenDigits(int n) {
 if(n == 0) {
   return 0;
 }
 
 if(n % 2 != 0) {
   return sumEvenDigits(n / 10);
 }
 
  return n % 10 + sumEvenDigits(n / 10);
}

int sumRange(int low, int high) {
  if(low == high) {
    return low; 
  }
  
  return high + sumRange(low, high - 1);
}

int multiply(int x, int y) {
 if(y < 0) {
   return multiply(-x, -y);
 }
  
 if(y == 0) {
   return 0;  
 }
 
 return x + multiply(x, y - 1);
}

int divide(int x, int y) {
  if(x < 0) {
    return -1;  
  }
  if(x == 0) {
    return 0;  
  }
 
 if(y < 0) {
   return 1 - divide(x + y, y);
 }
 
 return 1 + divide(x - y, y);
}



void draw() {
  background(1);
  fill(255);
  fill(0,255,0);
    if(squaresOverlapping(xPositions, yPositions, sizes, mouseX - 25, mouseY - 25, 50)) {
      fill(255, 0, 0); 
    }
    
  rect(mouseX - 25, mouseY - 25, 50, 50);
  
  fill(255);
  for(int i = 0; i < xPositions.length; i++) {
    square(xPositions[i], yPositions[i], sizes[i]);  
  }
    
}

void generateNonOverlappingSquares(int minX, int minY, int maxX, int maxY, int minSize, int maxSize, int count, int failAttempts) {  
  if(count == 0 || failAttempts == 0) {
    return;  
  }

  int size = (int)random(minSize, maxSize + 1);
  int xPos = (int)random(minX + size / 2, maxX - size / 2 + 1);
  int yPos = (int)random(minY + size / 2, maxY - size / 2 + 1);
  
  if(squaresOverlapping(xPositions, yPositions, sizes, xPos - size / 2, yPos - size / 2, size)) {
    generateNonOverlappingSquares(minX, minY, maxX, maxY, minSize, maxSize, count, failAttempts - 1);
    return;
  } 

  xPositions[squareCount - count] = xPos - size / 2;
  yPositions[squareCount - count] = yPos - size / 2;
  sizes[squareCount - count] = size;
  
  generateNonOverlappingSquares(minX, minY, maxX, maxY, minSize, maxSize, count - 1, failAttempts);
}

boolean squaresOverlapping(int[] xPositions, int[] yPositions, int[] sizes, int xPos, int yPos, int size) {
  for(int i = 0; i < xPositions.length; i++) {
    if(squaresOverlapping(xPositions[i], yPositions[i], sizes[i], xPos, yPos, size)) {
      return true;  
    }
  }
  return false;
}

boolean squaresOverlapping(int x1, int y1, int size1, int x2, int y2, int size2) {
  if(x1 + size1 < x2 || x1 > x2 + size2) {
    return false;
  }
  
  if(y1 + size1 < y2 || y1 > y2 + size2) {
    return false;
  }
  
  return true;
}
