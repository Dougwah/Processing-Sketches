boolean isArmstrongNumber(int x) {
    int numDigits = (int)(Math.log10(x) + 1);
    int totalSum = 0;
    for(int i = x; i > 0; i /= 10) {
        int currentSum = 1;
        for(int k = 0; k < numDigits; k++) {
            currentSum *= i % 10;
        }
        totalSum += currentSum;
    }
    if(x == totalSum) {
        return true;
    }
    return false;
}
