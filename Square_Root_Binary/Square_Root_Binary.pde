void setup() {
  long a = System.nanoTime();
  println(squareRoot(500));
  println((System.nanoTime() - a) * pow(10, -9));
}

double squareRoot(double x) {
  double low = 1;
  double high = x;
  double mid = 0;
  
  for (int i = 0; i < 100 && mid * mid != x; i++) {
    mid = (low + high) * 0.5;

    if (mid * mid > x) {
      high = mid;
    } else {
      low = mid;
    }
  }

  return mid;
}
