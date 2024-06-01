void setup() {
  println(sum(10));
  
  println(sumOddRecursive(2));
  println(sumEvenRecursive(10));
}

int sum(int n) {
  if(n == 0) {
    return n;
  }
  println(n);
  return n + sum(n - 1);
}

int sumOddRecursive(int n) {
  if(n <= 0) {
    return n;
  }
 
  return n * 2 - 1 + sumOddRecursive(n - 1);
}

int sumEvenRecursive(int n) {
  if(n <= 0) {
    return n;
  }
 
  return n * 2 + sumEvenRecursive(n - 1);
}
