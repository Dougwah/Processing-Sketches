void setup() {
  int result = 5;
  for(int i = 3; i < 21; i += 2) {
    result+=4;  
  }
  println(result);
  
  //3 5 7 9 11 13 15 17 19 21
  //9*4 + 5 = 41
  
  int x = 3;
  for(int i = 0; i <= 3; i++) {
    for(int k = 0; k <= 3; k++) {
      x++;  
    }
  }
  println(x);
  
  // 0 1 2 3, 0 1 2 3 = 4 x 4 = 16 * 1 + 3 = 19
  
  int y = 10;
  for(int i = 0; i <= 10; i+=2) {
    y+=i;
    i--;
  }
  println(y);
  
  // 65
  
  int h = 10;
  for(int i = 0; i <= 10; i+=2) {
    i--;
    h+=i;
  }
  println(h);
  
  // 54
  
  int n = 3;
  for(int i = -5; i < 15; i+= 4) {
    for(int k = 3; k < i; k++) {
      n*=2;
    }
  }
  println(n);
  
  int o = 3;
  for(int i = 0; i < 15; i+=4) {
    for(int k = i; k < 10; k++) {
      o+=5;
    }
  }
  println(o);
}
