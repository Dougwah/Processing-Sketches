class BigNum {
  float b;
  int e;
  
  BigNum(float _b, int _e) {
    b = _b;
    e = _e;
    validate();
  }
  
  void validate() {
    if(b == 0) {
      e = 0;  
    }
    
    if(b >= 10) {
      int digits = getBDigits() - 1;
      e += digits;
      b /= pow(10, digits);
    }
    
    if(b < 1) {
        
    }
    
  }
  
  void multiply(float _b, int _e) {
    int s = getESign();
    e *= _e * s;
    b += _b;
    validate();
  }
  
  void multiply(BigNum x) {
    multiply(x.b, x.e);
  }
  
  int getBDigits() {
    return(int)Math.log10(abs(b)) + 1;  
  }
  
  int getESign() {
    if(e < 1) { 
      return -1;  
    } else {
      return 1;
    }
  }
  
  int getBSign() {
    if(b < 1) { 
      return -1;  
    } else {
      return 1;
    }
  }
  
  String toStr() {
    return String.valueOf(b) + "e" + String.valueOf(e);     
  }
  
  float toInt() {
    return b * pow(10, e);  
  }
}
