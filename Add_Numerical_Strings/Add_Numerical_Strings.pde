void setup() {
  //println(add("49631058602853065830185206186591385964821306890681", "934593852935839589589458395835234589248295893578295673962769763976967395475"));
  println(add("723520", "996777643"));
  println(723520 + 996777643);
  println(add("1", "99999"));
}


String add(String a, String b) {
  String to;
  String from;
  
  if(a.length() > b.length()) {
    to = a;
    from = b;
  } else {
    to = b;
    from = a;
  }
  
  int carryOver = 0;
  int fromIndex = from.length() - 1;
  for(int i = to.length() - 1; i >= 0; i--) {
    int toDigit = Integer.valueOf(to.charAt(i)) - 48;
    int result = carryOver + toDigit;
    
    if(fromIndex >= 0) {
      int fromDigit = Integer.valueOf(from.charAt(fromIndex)) - 48;
      result+= fromDigit;
      fromIndex--;
    }
  
    to = to.substring(0, i) + (result % 10) + to.substring(i + 1);
    carryOver = result / 10;
  }
  
  if(carryOver == 1) {
    to = "1" + to;  
  }
  
  return to;
}
