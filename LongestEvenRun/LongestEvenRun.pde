void setup() {
  size(500, 500);  
//int[] data = {10, 60, 71, 120, 80, 100};
  //int[] data = {1, 7, 3, 9};
  //println(longestEvenRun(data));
  
  println(squaresOverlapping(40, 70, 10, 20, 50, 30));
}

void draw() {
  fill(255, 255, 255);
  square(20, 50, 30);
  fill(255, 0, 0);
  square(40, 70, 10);
}

boolean squaresOverlapping(int x1, int y1, int side1, int x2, int y2, int side2) {
  if( x1 - x2 <= side2 && y1 - y2 <= side2) {
    return true;
  }
  return false;
}


int[] longestEvenRun(int[] data) {
  if (data.length == 0) { return new int[0]; };
  int[] runStartIndexes = new int[data.length];
  int[] runEndIndexes = new int[data.length];

  boolean started = false;
  int currentRun = 0;
  
  for (int i = 0; i < data.length; i++) {
    if (i == data.length - 1 && started) {
      runEndIndexes[currentRun] = data.length;
      break;
    }

    if (data[i] % 2 == 0) {
      if (!started) {
        runStartIndexes[currentRun] = i;
        started = true;
      }
    } else {
      if (started) {
        runEndIndexes[currentRun] = i;
        started = false;
        currentRun++;
      }
    }
  }
  
  int longestRunSize = 0;
  int longestRunIndex = 0;
  for(int i = 0; i < runStartIndexes.length; i++) {
    int runSize = runEndIndexes[i] - runStartIndexes[i];
    if (runSize > longestRunSize) {
      longestRunSize = runSize;
      longestRunIndex = i;
    }
  }
  
  int[] resultRun = new int[longestRunSize];
  int currentIndex = 0;
  for(int i = runStartIndexes[longestRunIndex]; i < runEndIndexes[longestRunIndex]; i++) {
    resultRun[currentIndex] = data[i];
    currentIndex++;
  }
  
  return resultRun;
}
