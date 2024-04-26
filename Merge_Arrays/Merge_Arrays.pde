void setup() {
  println(merge(new int[] {9, 9, 11}, new int[] {1}));  
  println();  
  println(merge(new int[] {1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 5, 5, 5, 9, 9}, new int[] {2, 2, 2, 6})); 
}

int[] merge(int[] a, int[] b) {
  int[] to;
  int[] from;

  if(a.length >= b.length) {
    to = a;
    from = b;
  } else {
    to = b;
    from = a;
  }
  
  int[] result = new int[a.length + b.length];
  
  int addIndex = 0;
  for(int i = 0; i < to.length; i++) {
    result[i + addIndex] = to[i];
    
    for(int k = addIndex; k < from.length; k++) {
      
      
      if(from[k] >= to[i] && from[k] < to[i + 1]) {
        result[i + addIndex + 1] = from[k];
        addIndex++;
      }
      
      if (from[k] < to[0]) {
        result[i + addIndex] = from[k];
        addIndex++;
      }
      
    }


  }
  return result;
}
