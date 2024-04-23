void setup() {
  
/*
k > 4 %% k < 4
k > 3 && k < 3
k > 2 && k < 2
k > 1 && k < 1
k > 0 && k < 0


*/
  int n = 5;
  int size = n * 2 - 1; //9
  for(int i = 1; i <= size; i++) {
    for(int k = 1; k <= size; k++) {
      if(i > n) {
        if(k >= i) {
          print("* ");
        } else {
          print(" ");
        }
      } else {
        if(k > size - i) {
          print("* ");
        } else {
          print(" ");
        }
      }
    }
    println();
  }
}
