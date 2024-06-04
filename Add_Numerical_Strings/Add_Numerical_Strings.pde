void setup() {
  println(add("49631058602853065830185206186591385964821306890681", "934593852935839589589458395835234589248295893578295673962769763976967395475"));
}


String add(String a, String b) {
  String to = a;
  String from = b;
  if(a.length() > b.length()) {
    to = a;
    from = b;
  } else {
    to = b;
    from = a;
  }
  int carryOver = 0;
  for(int i = to.length() - 1; i > 0; i--) {
    println("i :" i + " 
    int toDigit = Integer.valueOf(to.charAt(i)) - 48;
    int fromDigit = 1; //Integer.valueOf(from.charAt(i - from.length() - to.length())) - 48;
    int result = toDigit + fromDigit + carryOver;
    println("toDigit: " + toDigit + " fromDigit: " + fromDigit + " result: " + result + " carry over: " + carryOver);
    println(to.substring(0, i) + " " + (result % 10) + " " + to.substring(i));
    to = to.substring(0, i) + (result % 10) + to.substring(i + 1);
         
    if(result >= 10) {
      carryOver = 1;
    } else {
      carryOver = 0;
    }
    
  }
  return to;
}
