boolean showPassedTests = false;
boolean showFailedTests = true;
void setup() {
  // === CONSTRUCTOR TESTS ===
  
  BigNum emptyConstructorTest = new BigNum();
  String emptyConstructorResult = "1.0E0";
  checkEqual(emptyConstructorTest.toStr(), emptyConstructorResult, "Empty Constructor");
 
  String[] constructorResults = {"1.0E0", "1.0E1", "2.5E2", "1.0E4", "1.2E4", "-1.0E1", "1.0E-1", "2.36E-2", "2.35E4", "2.1474836E9", "-2.0E1", "0.0E0", "1.0E2147483646", "0.0E0", "9.999999E2147483646", "0.0E0"};  
  String[] stringConstructorTests = {"1e0", "1e1", "2.5e2", "100e2", "12e3", "-1e1", "1e-1", "2.36e-2", "235e2", "2.14748364e9", "-200e-1", "0e1", "1e2147483646", "1e2147483647", "9.999999e2147483646", "9.9999999e2147483646"};
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
  BigNum[] checkEqualTestsFalse = {new BigNum(1, 1), new BigNum(2.5, 8), new BigNum(1.9999, 5), new BigNum(5.1, -5), new BigNum(-6.7, 1001)};
  boolean[] checkEqualResultsFalse = new boolean[checkEqualTestsFalse.length];
  for(int i = 0; i < checkEqualTestsTrue.length; i++) {
    checkEqual(checkEqualTestsTrue[i].equalTo(checkEqualTestsTrue[i]), checkEqualResultsTrue, i, "Bignums check equal - true"); 
    checkEqual(checkEqualTestsTrue[i].equalTo(checkEqualTestsFalse[i]), checkEqualResultsFalse, i, "Bignums check equal - false"); 
  }
  
  BigNum[] checkGreaterThanTests1 = {new BigNum(1, 1), new BigNum(2.5, 7), new BigNum(1.9999, 3), new BigNum(5, -6), new BigNum(-6.7, 1002), new BigNum(9.999, 2)};
  BigNum[] checkGreaterThanTests2 = {new BigNum(1, 0), new BigNum(2.4, 7), new BigNum(1.9999, 5), new BigNum(5.1, -5), new BigNum(-6.7, 1001), new BigNum(9.999, 2)};
  boolean[] checkGreaterThanResultsTrue = {true, true, false, false, true, false};
  for(int i = 0; i < checkGreaterThanTests1.length; i++) {
    checkEqual(checkGreaterThanTests1[i].greaterThan(checkGreaterThanTests2[i]), checkGreaterThanResultsTrue, i, "Bignums greater than");
  }
  
  BigNum[] checkLessThanTests1 = {new BigNum(1, 1), new BigNum(2.5, 7), new BigNum(1.9999, 3), new BigNum(5, -6), new BigNum(-6.7, 1002), new BigNum(9.999, 2)};
  BigNum[] checkLessThanTests2 = {new BigNum(1, 0), new BigNum(2.4, 7), new BigNum(1.9999, 5), new BigNum(5.1, -5), new BigNum(-6.7, 1001), new BigNum(9.999, 2)};
  boolean[] checkLessThanResults = {false, false, true, true, false, false};
  for(int i = 0; i < checkLessThanTests1.length; i++) {
    checkEqual(checkLessThanTests1[i].lessThan(checkLessThanTests2[i]), checkLessThanResults, i, "Bignums less than");
  }
  
  BigNum[] checkGreaterThanEqualTests1 = {new BigNum(1, 1), new BigNum(2.5, 7), new BigNum(1.9999, 3), new BigNum(5, -6), new BigNum(-6.7, 1002), new BigNum(9.999, 2), new BigNum(1, 1000000)};
  BigNum[] checkGreaterThanEqualTests2 = {new BigNum(1, 0), new BigNum(2.4, 7), new BigNum(1.9999, 5), new BigNum(5.1, -5), new BigNum(-6.7, 1001), new BigNum(9.999, 2), new BigNum(1, 1000000)};
  boolean[] checkGreaterThanEqualResults = {true, true, false, false, true, true, true};
  for(int i = 0; i < checkLessThanTests1.length; i++) {
    checkEqual(checkGreaterThanEqualTests1[i].greaterThanEqual(checkGreaterThanEqualTests2[i]), checkGreaterThanEqualResults, i, "Bignums greater than equal to");
  }
  
  BigNum[] checkLessThanEqualTests1 = {new BigNum(1, 1), new BigNum(2.5, 7), new BigNum(1.9999, 3), new BigNum(5, -6), new BigNum(-6.7, 1002), new BigNum(9.999, 2), new BigNum(1, 1000000)};
  BigNum[] checkLessThanEqualTests2 = {new BigNum(1, 0), new BigNum(2.4, 7), new BigNum(1.9999, 5), new BigNum(5.1, -5), new BigNum(-6.7, 1001), new BigNum(9.999, 2), new BigNum(1, 1000000)};
  boolean[] checkLessThanEqualResults = {false, false, true, true, false, true, true};
  for(int i = 0; i < checkLessThanTests1.length; i++) {
    checkEqual(checkLessThanEqualTests1[i].lessThanEqual(checkLessThanEqualTests2[i]), checkLessThanEqualResults, i, "Bignums greater than equal to");
  }
  
  String[] setRoundResults = {"1e0", "1.25e5", "1.24e3", "1.99e8", "1.75e100", "2.36e-7", "1e11"};
  BigNum[] setRoundTests = {new BigNum(1, 0), new BigNum(1.245, 5), new BigNum(1.243, 3), new BigNum(1.989, 8), new BigNum(1.75353, 100), new BigNum(2.356, -7), new BigNum(9.9999, 10)};
  for(int i = 0; i < setRoundResults.length; i++) {
    setRoundTests[i].setRound(2);
    checkEqual(setRoundTests[i].fTrim(), setRoundResults, i, "Bignum round to 2 decimals");
  }
  
  String[] addResults = {"2e0", "1.5e20", "6.123456e70", "9e99999999", "1e8", "-2e5", "5e-1", "1e8", "1e8", "1.0000001e7", "0e0", "5e-10", "-6e-10", "2.7555e2", "2.147493e9", "9.556555e10"};
  String[] subResults = {"0e0", "0e0", "5.876544e70", "3e99999999", "5e8", "4e5", "0e0", "1e8", "-1e8", "9.999999e6", "2e1000", "5e-10", "6e-10", "3.555e1", "2.147473e9", "9.554555e10"};
  BigNum[] addTests1 = {new BigNum(1, 0), new BigNum(7.5, 19), new BigNum(6, 70), new BigNum(6, 99999999), new BigNum(3, 8), new BigNum(1, 5), new BigNum(2.5, -1), new BigNum(1, 8), new BigNum(1, 0), new BigNum(1, 7), new BigNum(1, 1000), new BigNum(5, -10), new BigNum(5, -20), new BigNum(1.5555, 2), new BigNum(2.147483, 9), new BigNum(9.555555, 10)};
  BigNum[] addTests2 = {new BigNum(1, 0), new BigNum(7.5, 19), new BigNum(1.23456, 69), new BigNum(3,99999999), new BigNum(-2, 8), new BigNum(-3, 5), new BigNum(2.5, -1), new BigNum(1, 0), new BigNum(1, 8), new BigNum(1, 0), new BigNum(-1, 1000), new BigNum(-5, -20), new BigNum(-6, -10), new BigNum(1.2, 2), new BigNum(1, 4), new BigNum(1, 7)};
  for(int i = 0; i < addResults.length; i++) {
    checkEqual(addTests1[i].getAdd(addTests2[i]).fTrim(), addResults, i, "Bignum add");
    checkEqual(addTests1[i].getSub(addTests2[i]).fTrim(), subResults, i, "Bignum subtract");
  }

  String[] multResults = {"0e0", "0e0", "3e5", "2.25e10", "4e100000100", "7.2e1", "8.1e642316431", "-2.1e751", "1e4", "1e-4", "7.1289e-8", "2e0", "3.34084e1", "-4.63e-3462347", "1e120000000", "2.5e1999980001", "3e2147483646", "0e0"};
  BigNum[] multTests1 = {new BigNum(0, 0), new BigNum(1, 1000), new BigNum(1.5, 5), new BigNum(1.5, 5), new BigNum(2, 100000000), new BigNum(9, 0), new BigNum(9, 642316430), new BigNum(-7, 500), new BigNum(-1, 2), new BigNum(1, -2), new BigNum(2.67, -2), new BigNum(2, -10), new BigNum(5.78, -10000), new BigNum(9.26, -3462346), new BigNum(1, 60000000), new BigNum(5, 999990000), new BigNum(1, Integer.MAX_VALUE - 1), new BigNum(1, Integer.MAX_VALUE)};
  BigNum[] multTests2 = {new BigNum(0, 0), new BigNum(0, 1000), new BigNum(2, 0), new BigNum(1.5, 5), new BigNum(2, 100), new BigNum(8, 0), new BigNum(9, 0), new BigNum(3, 250), new BigNum(-1, 2), new BigNum(1, -2), new BigNum(2.67, -6), new BigNum(1, 10), new BigNum(5.78, 10000), new BigNum(-5, -2), new BigNum(1, 60000000), new BigNum(5, 999990000), new BigNum(3, 0), new BigNum(3, 100)};
  for(int i = 0; i < multResults.length; i++) {
    checkEqual(multTests1[i].getMult(multTests2[i]).fTrim(), multResults, i, "Bignum Mult");
  }
 
  // === MISC FUNCTION TESTS ===
  
  String[] validateResults = {"1.0E3", "1.25E4", "-3.5E8", "2.0E0", "1.0E-4", "1.0E3", "1.0E0", "5.0E9", "9.999999E20", "2.1474836E10"};
  BigNum[] validateTests = {new BigNum(100, 1), new BigNum(125, 2), new BigNum(-350, 6), new BigNum(20, -1), new BigNum(0.001, -1), new BigNum(10, 2), new BigNum(10, -1), new BigNum(0.5, 10), new BigNum(9.999999, 20), new BigNum(2147483647, 1)};
  for(int i = 0; i < validateTests.length; i++) {
    checkEqual(validateTests[i].toStr(), validateResults, i, "Validate Number");  
  }
  
  int[] getExpoResults = {0, 1, 2, 3, 4, 5, 6, 6, -7, -6, -5, -4, -3, -2, -2, -1, -2, -5};
  float[] getExpoTests = {5, 76, 754, 9999, 64535, 123456, 8630782, 9999999, 0.0000006, 0.000001, 0.00005, 0.0007, 0.001, 0.02, 0.01, 0.8, 0.0236, -0.0000557};
  for(int i = 0; i < getExpoResults.length; i++) {
    checkEqual(getExpo(getExpoTests[i]), getExpoResults, i, "Get expo");
  }
  
  float[] getBaseResults = {5.0, 7.6, 7.54, 9.999, -6.4535, 1.23456, 8.630782, 1.0, 1.26, -5.1, 5.0, 7.0, 1.0, 2.0, 1.0, 8.0, 1.05, 2.36, -5.5};
  float[] getBaseTests = {5, 76, 754, 9999, -64535, 123456, 8630782, 99999999, 0.0000126, -0.000051, 0.00005, 0.0007, 0.001, 0.02, 0.01, 0.8, 10.5, 0.0236, -0.000055};
  for(int i = 0; i < getBaseResults.length; i++) {
    checkEqual(getBase(getBaseTests[i]), getBaseResults, i, "Get base");
  }
  
  float[] roundFloatResults0 = {0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 100.0, -999.0, -999.0, -1000, -1000, -1000, -16356.0};
  float[] roundFloatTests0 = {0.1, 0.15, 0.156, 0.154, 0.9, 0.99, 0.999, 0.994, 0.001, 0.005, 100, -999, -999.4, -999.5, -999.99, -999.995, -16356.4437};
  for(int i = 0; i < roundFloatResults0.length; i++) {
    checkEqual(roundFloat(roundFloatTests0[i], 0), roundFloatResults0, i, "Round Float 0 places");  
  }
  
  float[] roundFloatResults1 = {0.1, 0.2, 0.2, 0.2, 0.9, 1, 1.0, 1, 0.0, 0.0, 100.0, -999.0, -999.4, -999.5, -1000, -1000, -16356.4};
  float[] roundFloatTests1 = {0.1, 0.15, 0.156, 0.154, 0.9, 0.99, 0.999, 0.994, 0.001, 0.005, 100, -999, -999.4, -999.5, -999.99, -999.995, -16356.4437};
  for(int i = 0; i < roundFloatResults1.length; i++) {
    checkEqual(roundFloat(roundFloatTests1[i], 1), roundFloatResults1, i, "Round Float 1 place");  
  }
  
  float[] roundFloatResults2 = {0.1, 0.15, 0.16, 0.15, 0.9, 0.99, 1.0, 0.99, 0.0, 0.01, 100.0, -999.0, -999.4, -999.5, -999.99, -1000, -16356.44};
  float[] roundFloatTests2 = {0.1, 0.15, 0.156, 0.154, 0.9, 0.99, 0.999, 0.994, 0.001, 0.005, 100, -999, -999.4, -999.5, -999.99, -999.995, -16356.4437};
  for(int i = 0; i < roundFloatResults2.length; i++) {
    checkEqual(roundFloat(roundFloatTests2[i], 2), roundFloatResults2, i, "Round Float 2 places");  
  }
    
  float[] roundFloatResults3 = {0.1, 0.15, 0.156, 0.154, 0.9, 0.99, 0.999, 0.994, 0.001, 0.005, 100.0, -999.0, -999.4, -999.5, -999.99, -999.995, -1636.444, -1800.79, -1000.786};
  float[] roundFloatTests3 = {0.1, 0.15, 0.156, 0.154, 0.9, 0.99, 0.999, 0.994, 0.001, 0.005, 100, -999, -999.4, -999.5, -999.99, -999.995, -1636.4435, -1800.7899, -1000.7855};
  for(int i = 0; i < roundFloatResults3.length; i++) {
    checkEqual(roundFloat(roundFloatTests3[i], 3), roundFloatResults3, i, "Round Float 3 places");  
  }
  
  String[] trimFloatResults = {"1", "2", "8", "974", "164236", "-775", "0.1", "1251.265", "0.001"};
  float[] trimFloatTests = {1.0, 2.0, 8.0, 974.0, 164236.0, -775, 0.1, 1251.265, 0.001};
  for(int i = 0; i < trimFloatResults.length; i++) {
    checkEqual(trimFloat(trimFloatTests[i]), trimFloatResults, i, "Trim Float");  
  }
  
  // === CONVERSION TESTS ===
  
  String[] toStrResults = {"1.0E0", "9.999999E1", "-2.0E1", "2.0E-1", "0.0E0" , "1.0E2147483646", "1.5E-1"};
  BigNum[] toStrTests = {new BigNum(1, 0), new BigNum(9.999999, 1), new BigNum(-2, 1), new BigNum(2, -1), new BigNum(1, 2147483647), new BigNum(1, 2147483646), new BigNum(1.5, -1)};
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
  
  BigNum a = new BigNum(1, 0);
  for(int i = 0; i < 100000; i++) {
    a.setMult(1, 10);
    println(a.fRound());
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
