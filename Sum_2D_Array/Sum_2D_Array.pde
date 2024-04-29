void setup() {
  println(sum(new int[][] {
  new int[] {1,2,3,4,5,6,7,8,9,10,11,12,13,14},
  new int[]{2,423,4,-24},
  null,
  new int[] {100}
  }));
}
int sum(int[][] data) {
    int result = 0;
    if(data == null) {
        return result;
    }
    for(int i = 0; i < data.length; i++) {
      if(data[i] == null) {
        continue;  
      }
      for(int k = 0; k < data[i].length; k++) {
            result += data[i][k];
        }
    }
    return result;
}
