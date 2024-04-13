void setup() {
  size(500, 500);  
  int[] data = {10, 60, 71, 120, 80, 100};
  //int[] data = {1, 7, 3, 9};
  println(longestEvenRun(data));
}

void draw() {}

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
