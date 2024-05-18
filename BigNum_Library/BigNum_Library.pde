boolean showPassedTests = false;
void setup() {
  // === CONSTRUCTOR TESTS ===
  
  BigNum y = new BigNum(5.54, 5);
  //println(y.fTrim0());
  //println(y.fSmall());
  //println(y.fRound());
  //println(y.toStr());
  //println(y.toFloat());
  println(y.fSuffix());

  
  
  BigNum emptyConstructorTest = new BigNum();
  String emptyConstructorResult = "1.0E0";
  checkEqual(emptyConstructorTest.toStr(), emptyConstructorResult, "Empty Constructor");
  
  String[] constructorResults = {"1.0E0", "1.0E1", "2.5E2", "1.0E4", "1.2E4", "-1.0E1", "1.0E-1", "2.36E-2", "2.35E4", "2.1474736E9", "-2.0E1"};  
  String[] stringConstructorTests = {"1e0", "1e1", "2.5e2", "100e2", "12e3", "-1e1", "1e-1", "2.36e-2", "235e2", "2.147473674e9", "-200e-1"};
  for(int i = 0; i < stringConstructorTests.length; i++) {
    BigNum x = new BigNum(stringConstructorTests[i]);
    checkEqual(x.toStr(), constructorResults, i, "String Constructor");
  }
  float[] floatConstructorTests = {1, 10, 250, 10000, 12000, -10, 0.1, 0.0236, 23500, 2147473674, -20};
  for(int i = 0; i < floatConstructorTests.length; i++) {
    BigNum x = new BigNum(floatConstructorTests[i]);
    checkEqual(x.toStr(), constructorResults, i, "Float Constructor");
  }
  
  // === MISC FUNCTION TESTS ===
  
  String[] validateResults = {"1.0E3", "1.25E4", "-3.5E8", "2.0E0", "1.0E-4", "1.0E3", "1.0E0", "5.0E9", "9.999999E20", "2.1474736E10"};
  BigNum[] validateTests = {new BigNum(100, 1), new BigNum(125, 2), new BigNum(-350, 6), new BigNum(20, -1), new BigNum(0.001, -1), new BigNum(10, 2), new BigNum(10, -1), new BigNum(0.5, 10), new BigNum(9.999999, 20), new BigNum(2147473674, 1)};
  for(int i = 0; i < validateTests.length; i++) {
    checkEqual(validateTests[i].toStr(), validateResults, i, "Validate Number");  
  }
  
  
  // === CONVERSION TESTS ===
  
  String[] toStrResults = {"1.0E0", "9.999999E1", "-2.0E1", "2.0E-1", "1.0E2147473674", "1.5E-1"};
  BigNum[] toStrTests = {new BigNum(1, 0), new BigNum(9.999999, 1), new BigNum(-2, 1), new BigNum(2, -1), new BigNum(1, 2147473674), new BigNum(1.5, -1)};
  for(int i = 0; i < toStrTests.length; i++) {
    checkEqual(toStrTests[i].toStr(), toStrResults, i, "Convert to string");
  }
  
  float[] toFloatResults = {1.0, 150.0, 123456.0, -1.0, 0.001, 9.99, -0.000012345};
  BigNum[] toFloatTests = {new BigNum(1, 0), new BigNum(1.5, 2), new BigNum(1.23456, 5), new BigNum(-1, 0), new BigNum(1, -3), new BigNum(9.99, 0), new BigNum(-1.2345, - 5)};
  for(int i = 0; i < toFloatTests.length; i++) {
    checkEqual(toFloatTests[i].toFloat(), toFloatResults, i, "Convert to float");
  }
  
  // === FORMAT TESTS ===
  
  // == SUFFIXES ==
  
  String[] suffixPositiveBaseResults = {"2.45", "24.5", "245", "2.45K", "24.5K", "245K", "2.45M", "24.5M", "245M", "2.45B"};
  for(int i = 0; i < 10; i++) {
    BigNum x = new BigNum(2.45472436, i);
    String str = x.fSuffix();
    checkEqual(str, suffixPositiveBaseResults, i, "Format Suffix positive base");
  }
  
  String[] suffixNegativeBaseResults = {"-2.45", "-24.5", "-245", "-2.45K", "-24.5K", "-245K", "-2.45M", "-24.5M", "-245M", "-2.45B"};
  for(int i = 0; i < 10; i++) {
    BigNum x = new BigNum(-2.45472436, i);
    String str = x.fSuffix();
    checkEqual(str, suffixNegativeBaseResults, i, "Format Suffix negative base");
  }
  
  String[] suffixNegativeExponentResults = {"2.45", "0.245", "0.0245", "0.00245", "2.45E-4", "2.45E-5", "2.45E-6", "2.45E-7", "2.45E-8", "2.45E-9",};
  for(int i = 0; i < 10; i++) {
    BigNum x = new BigNum(2.45472436, -i);
    String str = x.fSuffix();
    checkEqual(str, suffixNegativeExponentResults, i, "Format Suffix negative exponent");
  }
  
  // == ROUNDED ==
  
  String[] formatRoundedPositiveBaseResults = {"1.22e10", "5.6e6", "9.98e5", "1e5", "1e500", "1.01e10"};
  BigNum[] formatRoundedPositiveTests = {new BigNum(1.22, 10), new BigNum(5.600001, 6), new BigNum(9.975, 5), new BigNum(9.999, 4), new BigNum(1, 500), new BigNum(1.005, 10)};
  for(int i = 0; i < formatRoundedPositiveTests.length; i++) {
    checkEqual(formatRoundedPositiveTests[i].fRound(), formatRoundedPositiveBaseResults, i, "Format Rounded positive base");
  }
  
  String[] formatRoundedNegativeBaseResults = {"-1.22e10", "-5.6e6", "-9.98e5", "-1e5", "-1e500"};
  BigNum[] formatRoundedNegativeTests = {new BigNum(-1.22, 10), new BigNum(-5.600001, 6), new BigNum(-9.975, 5), new BigNum(-9.999, 4), new BigNum(-1, 500)};
  for(int i = 0; i < formatRoundedNegativeTests.length; i++) {
    checkEqual(formatRoundedNegativeTests[i].fRound(), formatRoundedNegativeBaseResults, i, "Format Rounded negative base");
  }
  
  String[] formatRoundedNegativeExponentResults = {"1.22e-10", "5.6e-6", "9.98e-5", "1e-3", "1e-500"};
  BigNum[] formatRoundedNegativeExponentTests = {new BigNum(1.22, -10), new BigNum(5.600001, -6), new BigNum(9.975, -5), new BigNum(9.999, -4), new BigNum(1, -500)};
  for(int i = 0; i < formatRoundedNegativeExponentTests.length; i++) {
    checkEqual(formatRoundedNegativeExponentTests[i].fRound(), formatRoundedNegativeExponentResults, i, "Format Rounded negative exponent");
  }
  
  // ==
  
}

boolean checkEqual(float result, float[]correctResults, int index, String testName) {
  if(result != correctResults[index]) {
    println("[-] Test Failed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]); 
    return false;
  }
  
  if(showPassedTests) {
    println("[+] Test Passed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]);   
  }
  
  return true;
}

boolean checkEqual(BigNum b, BigNum[] correctResults, int index, String testName) {
    return true;
}

boolean checkEqual(String result, String[] correctResults, int index, String testName) {
  if(!result.equals(correctResults[index])) {
    println("[-] Test Failed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]); 
    return false;
  }
  if(showPassedTests) {
    println("[+] Test Passed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]);   
  }
  
  return true;
}

boolean checkEqual(String result, String correctResult, String testName) {
  if(!result.equals(correctResult)) {
    println("[-] Test Failed for: " + testName +  ", Expected Result: " + correctResult); 
    return false;
  }
  if(showPassedTests) {
    println("[+] Test Passed for: " + testName + " - Result: " + result + ", Expected Result: " + correctResult);   
  }
  
  return true;
}
