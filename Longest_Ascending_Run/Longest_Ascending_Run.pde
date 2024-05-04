void setup() {
  println(longestAscendingSequence(new int[] {9,7,5,3,1}));  
}

int[] longestAscendingSequence(int[] x) {
  if(x == null || x.length == 0) {
      return new int[0];
  }
  if(x.length == 1) {
      return new int[] {x[0]};
  }
  int[] startIndexes = new int[x.length];
  int[] endIndexes = new int[x.length];
  int runCount = 0;
  boolean inRun = false;
  for(int i = 0; i < x.length; i++) {
    
    if(i == x.length - 1) {
      if(inRun) {
        endIndexes[runCount] = i;  
      }
      break;
    }
    
    if(x[i] <= x[i + 1]) {
      if(!inRun) {
        startIndexes[runCount] = i;
        inRun = true; 
      } 
    } else if(inRun) {
      endIndexes[runCount] = i;
      inRun = false; 
      runCount++;
    }
  }
  
  int largestIndex = 0;
  int largestLength = 0;
  for(int i = x.length - 1; i >= 0 ; i--) {
    if(endIndexes[i] - startIndexes[i] + 1 >= largestLength) {
      largestLength = endIndexes[i] - startIndexes[i] + 1;
      largestIndex = i;
    }
  }
  
  int[] result = new int[endIndexes[largestIndex] - startIndexes[largestIndex] + 1];
  
  int a = 0;
  for(int i = startIndexes[largestIndex]; i <= endIndexes[largestIndex]; i++) {
    result[a] = x[i];  
    a++;
  }
  
  return result;
  
}
