void setup() {
  println(subtract("13", "8") + "\n"); // 5
  println(subtract("97", "21") + "\n"); // 76
  println(subtract("1635", "28") + "\n"); //1607
  println(1635 - 28 + "\n"); // 1607
  println(subtract("8703575", "4876045") + "\n");
  println(8703575 - 4876045 + "\n");
  println(subtract("8703575", "9045") + "\n"); // 8694530
  println(8703575 - 9045);
  println(subtract("903456839524786593725496724922543626", "6363643563465464635"));
}

// a - b
String subtract(String a, String b) {
  if(a.equals(b)) {
    return "0";  
  }
  int bIndex = b.length() - 1;
  int carryOver = 0;
  for(int i = a.length() - 1; i >= 0; i--) {
    int aDigit = Integer.valueOf(a.charAt(i)) - 48;
    
    if(bIndex >= 0) {
      int bDigit = Integer.valueOf(b.charAt(bIndex)) - 48;
      int result = aDigit - bDigit - carryOver;
      println("a Before: " + a);
      println("aDigit: " + aDigit + " bDigit: " + bDigit + " carryOver: " + carryOver + " result: " 
      + result);
      if(result < 0) {
        carryOver = 1;
        if(a.length() <= 2) {
          a = String.valueOf(-result);
          break;
        } else {
          a = a.substring(0, i) + (10 + result) + a.substring(i + 1); 
        }
      } else {
        a = a.substring(0, i) + result + a.substring(i + 1);
      }
      bIndex--;
    } else {
    
    //if(carryOver != 0) {
      int result = aDigit - carryOver;
      println("aDigit: " + aDigit + " carryOver: " + carryOver + " result: " + result);
      if(result < 0) {
        carryOver = 1;
        a = a.substring(0, i) + (10 + result) + a.substring(i + 1);
      } else {
        carryOver = 0;
        a = a.substring(0, i) + result + a.substring(i + 1);
      }
    }
    //}
    println("a After: " + a + "\n");
  }
  return a;
}
