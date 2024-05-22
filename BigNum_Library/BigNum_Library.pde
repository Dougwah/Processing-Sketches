boolean showPassedTests = false;
boolean showFailedTests = true;
void setup() {
  // === CONSTRUCTOR TESTS ===
  
  BigNum emptyConstructorTest = new BigNum();
  String emptyConstructorResult = "1.0E0";
  checkEqual(emptyConstructorTest.toStr(), emptyConstructorResult, "Empty Constructor");
  
  String[] constructorResults = {"1.0E0", "1.0E1", "2.5E2", "1.0E4", "1.2E4", "-1.0E1", "1.0E-1", "2.36E-2", "2.35E4", "2.1474836E9", "-2.0E1"};  
  String[] stringConstructorTests = {"1e0", "1e1", "2.5e2", "100e2", "12e3", "-1e1", "1e-1", "2.36e-2", "235e2", "2.14748364e9", "-200e-1"};
  for(int i = 0; i < stringConstructorTests.length; i++) {
    BigNum x = new BigNum(stringConstructorTests[i]);
    checkEqual(x.toStr(), constructorResults, i, "String Constructor");
  }
  float[] floatConstructorTests = {1, 10, 250, 10000, 12000, -10, 0.1, 0.0236, 23500, 2147483647, -20};
  for(int i = 0; i < floatConstructorTests.length; i++) {
    BigNum x = new BigNum(floatConstructorTests[i]);
    checkEqual(x.toStr(), constructorResults, i, "Float Constructor");
  }
  
  // === MATH TESTS ===
  
  BigNum[] checkEqualTestsTrue = {new BigNum(1, 0), new BigNum(2.5, 7), new BigNum(1.9999, 3), new BigNum(5, -5), new BigNum(-6.7, 1000)};
  boolean[] checkEqualResultsTrue = {true, true, true, true, true};
  BigNum[] checkEqualTestsFalse = {new BigNum(1, 1), new BigNum(2.5, 8), new BigNum(1.9999, 5), new BigNum(5, -6), new BigNum(-6.7, 1001)};
  boolean[] checkEqualResultsFalse = new boolean[checkEqualTestsFalse.length];
  for(int i = 0; i < checkEqualTestsTrue.length; i++) {
    checkEqual(checkEqualTestsTrue[i].equalTo(checkEqualTestsTrue[i]), checkEqualResultsTrue, i, "Bignums check equal - true"); 
    checkEqual(checkEqualTestsTrue[i].equalTo(checkEqualTestsFalse[i]), checkEqualResultsFalse, i, "Bignums check equal - false"); 
  }
 

  // === MISC FUNCTION TESTS ===
  
  String[] validateResults = {"1.0E3", "1.25E4", "-3.5E8", "2.0E0", "1.0E-4", "1.0E3", "1.0E0", "5.0E9", "9.999999E20", "2.1474836E10"};
  BigNum[] validateTests = {new BigNum(100, 1), new BigNum(125, 2), new BigNum(-350, 6), new BigNum(20, -1), new BigNum(0.001, -1), new BigNum(10, 2), new BigNum(10, -1), new BigNum(0.5, 10), new BigNum(9.999999, 20), new BigNum(2147483647, 1)};
  for(int i = 0; i < validateTests.length; i++) {
    checkEqual(validateTests[i].toStr(), validateResults, i, "Validate Number");  
  }
  
  int[] getExpoResults = {0, 1, 2, 3, 4, 5, 6, 7, -7, -6, -5, -4, -3, -2, -2, -1};
  float[] getExpoTests = {5, 76, 754, 9999, 64535, 123456, 8630782, 99999999, 0.0000006, 0.000001, 0.00005, 0.0007, 0.001, 0.02, 0.01, 0.8};
  for(int i = 0; i < getExpoResults.length; i++) {
    checkEqual(getExpo(getExpoTests[i]), getExpoResults, i, "Get expo");
  }

  // === CONVERSION TESTS ===
  
  String[] toStrResults = {"1.0E0", "9.999999E1", "-2.0E1", "2.0E-1", "1.0E2147483647", "1.5E-1"};
  BigNum[] toStrTests = {new BigNum(1, 0), new BigNum(9.999999, 1), new BigNum(-2, 1), new BigNum(2, -1), new BigNum(1, 2147483647), new BigNum(1.5, -1)};
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
  
  String[] suffixPositiveBaseResults = {"2.45", "24.55", "245.47", "2.45K", "24.5K", "245K", "2.45M", "24.5M", "245M", "2.45B"};
  for(int i = 0; i < 10; i++) {
    BigNum x = new BigNum(2.45472436, i);
    String str = x.fSuffix();
    checkEqual(str, suffixPositiveBaseResults, i, "Format Suffix positive base");
  }
  
  String[] suffixNegativeBaseResults = {"-2.45", "-24.55", "-245.47", "-2.45K", "-24.5K", "-245K", "-2.45M", "-24.5M", "-245M", "-2.45B"};
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
  
  String[] formatRoundedPositiveBaseResults = {"1.22e10", "5.6e6", "9.98e5", "1e5", "1e500", "1.01e10", "1.27e5"};
  BigNum[] formatRoundedPositiveTests = {new BigNum(1.22, 10), new BigNum(5.600001, 6), new BigNum(9.975, 5), new BigNum(9.999, 4), new BigNum(1, 500), new BigNum(1.005, 10), new BigNum(1.26737, 5)};
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
  
  // == SMALL ==
  
  String[] formatSmallPositiveExponentResults = {"-1", "-1.2", "-1.25", "1000", "1234", "123456", "1234567", "2.1474836E9", "111", "1111111", "1.25", "2"};
  BigNum[] formatSmallPositiveExponentTests = {new BigNum(-1, 0), new BigNum(-1.2, 0), new BigNum(-1.25, 0), new BigNum(1, 3), new BigNum(1.234, 3), new BigNum(1.23456, 5), new BigNum(1.234567, 6), new BigNum(2.147483647, 9), new BigNum(1.11, 2), new BigNum(1.111111, 6), new BigNum(1.24567, 0), new BigNum(1.999, 0)};
  for(int i = 0; i < formatSmallPositiveExponentTests.length; i++) {
    checkEqual(formatSmallPositiveExponentTests[i].fSmall(), formatSmallPositiveExponentResults, i, "Format Small positive exponent");
  }
  
  String[] formatSmallNegativeExponentResults = {"-0.01", "0.1", "1.65E-5", "1.66E-5",};
  BigNum[] formatSmallNegativeExponentTests = { new BigNum(-1, -2), new BigNum(1, -1), new BigNum(1.654, -5), new BigNum(1.656, -5)};
  for(int i = 0; i < formatSmallNegativeExponentTests.length; i++) {
    checkEqual(formatSmallNegativeExponentTests[i].fSmall(), formatSmallNegativeExponentResults, i, "Format Small negative exponent");
  }

}

boolean checkEqual(int result, int[]correctResults, int index, String testName) {
  if(showFailedTests && result != correctResults[index]) {
    println("[-] Test Failed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]); 
    return false;
  }
  
  if(showPassedTests) {
    println("[+] Test Passed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]);   
  }
  
  return true;
}

boolean checkEqual(float result, float[]correctResults, int index, String testName) {
  if(showFailedTests && result != correctResults[index]) {
    println("[-] Test Failed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]); 
    return false;
  }
  
  if(showPassedTests) {
    println("[+] Test Passed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]);   
  }
  
  return true;
}

boolean checkEqual(boolean result, boolean[] correctResults, int index, String testName) {
    if(result != correctResults[index]) {
      println("[-] Test Failed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]); 
      return false;
    }
    if(showPassedTests) {
      println("[+] Test Passed for: " + testName + " - Test Case: " + index + ", Result: " + result + ", Expected Result: " + correctResults[index]);   
    }
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
