void setup() {
  //println(sumPrimes(1000));
  //println(nearlyPrime(62710561));
  //println(countFactors(10));
  
  println(countPrimeFactors(99999999));
  
}

int sumPrimes(int x) {
  int result = 0;
  for(int i = 2; i <= x; i++) {
    if(isPrime(i)) {
      result+=i;
    }
  }
  return result;
}

boolean isPrime(int x) {
  for(int i = 2; i <= x / 2; i++) {
    if(x % i == 0) {
      return false;  
    }
  }
  return true;
}

boolean nearlyPrime(int x) {
  boolean has1Factor = false;
  for(int i = 2; i <= x / 2; i++) {
    if(x % i == 0) {
      if(has1Factor) {
        return false;  
      }
      has1Factor = true;
    }
  }
  return has1Factor;
}

int countFactors(int x) {
  int result = 2;
  for(int i = 2; i <= x / 2; i++) {
    if(x % i == 0) {
      result++;  
    }
  }
  return result;
}


int countPrimeFactors(int x) {
  int startTime = millis();
  int loops = 0;
  int result = 0;
  if(isPrime(x)) {
    result++;  
  }
  for(int i = 3; i <= sqrt(x); i += 2) {
    loops++;
    if(x % i == 0 && isPrime(i)) {
      result++; 
    }
  }
  println((millis() - startTime) / 1000., loops);
  return result;  
}
