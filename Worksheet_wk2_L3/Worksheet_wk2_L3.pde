void setup() {
  int[] a = new int[] {20, 20};
  int[] b = new int[] {10, 70, 20, 90};

  boolean c = isSubsetOf(a, b);
  println(c);
}

boolean isSubsetOf(int[] a, int[] b) {
  boolean subSet = true;
  for (int i = 0; i < a.length; i++) {
    if (getValueCount(a, a[i]) > getValueCount(b, a[i])) {
      subSet = false;
    }  
  }
  return subSet;
}

int getValueCount(int[] a, int value) {
  int count = 0;
  for (int i = 0; i < a.length; i++) {
    if (a[i] == value) {
      count += 1;
    }
  }
  return count;
}

String checkMark(int mark) {
    
  
}
