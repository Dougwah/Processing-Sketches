void setup() {
  println(binaryFunc(2147483647));
  println(binaryFunc(13));
}

String binaryFunc(int x) {
    String temp = "";
    String result = "";
    if (x == 0) {
        return "0";
    }
    for(int i = x; i > 0; i /= 2) {
        temp += Integer.toString(i % 2);
    }
    for(int i = temp.length() - 1; i >= 0; i--) {
        result += temp.charAt(i);
    }
    return result;
}
