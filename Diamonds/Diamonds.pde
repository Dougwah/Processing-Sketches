void setup() {
int n = 5;
  for(int i = 1; i <= n * 2 - 1; i++) {
    for(int k = 1; k <= n * 2 - 1; k++) {
      if(k >= n / 2 - i && k <= n / 2 + i) {
        print("* ");   
      } else {
        print(" ");
      }
    }
    println();
  }
}
