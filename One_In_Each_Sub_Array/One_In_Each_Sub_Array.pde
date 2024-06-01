void setup() {
  println(oneInEachSubArray(new int[] {10, 70, 20, 90, 50, 80, 60, 10, 20, 10, 100, 70}, 3)); 
}

boolean oneInEachSubArray(int[] a, int n) {
  int subLength = a.length / n;
  int[][] subArrays = new int[n][subLength];
  int subIndex = 0;
  
  for(int i = 0; i < a.length; i+= subLength) {
      for(int k = 0; k < subLength; k++) {
        subArrays[subIndex][k] = a[i + k];
    }
    subIndex++;
  }
  
  for(int i = 0; i < subLength; i++) { // loop Through first sub array
    int instances = 0;
    for(int k = 1; k < n; k++) { // Access each other sub array
      for(int j = 0; j < subLength; j++) { // Loop through each element in the sub array and compare to the values in the first array
        if(subArrays[0][i] == subArrays[k][j]) {
          instances++;
          break;
        }
      }
    }
    if(instances == n - 1) {
      return true;
    }
  }
    
  return false;
}
