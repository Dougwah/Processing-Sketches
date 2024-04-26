void setup() {
  println(isPalindrome(7007));
  println(isPalindrome(1));
  println(isPalindrome(0));
  println(isPalindrome(-7007));
  println(isPalindrome(62346426));
  println(isPalindrome(Integer.MAX_VALUE));
  
  println(factorial(5));
  println(5*4*3*2*1);
  println(factorial(1));
  
  println(powerOf(4, 4));
}

boolean isPalindrome(int x) {
  x = Math.abs(x);
  for(int i = x; i > 0; i /= 10) {
    int e = (int)(Math.log10(i));
    int y = x / (int)Math.pow(10, e) % 10;
    //println("e : " + e + "\n");
    //println("y : " + y + "\n");
    //println("i : " + i % 10 + "\n\n");
    if (i % 10 != y) {
      return false;  
    } 
  }
  return true;
}

int factorial(int x) {
  int result = 1;
  for(int i = x; i >= 1; i--) {
    result *= i;
  }
  return result;
}

int powerOf(int b, int e) {
  int result = b;
  for(int i = 1; i < e; i++) {
    result *= b;
  }
  return result;
}
