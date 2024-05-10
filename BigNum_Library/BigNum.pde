int precision = 8;

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
    
    if(b >= 10 || b < 1) {
      int digits = getBDigits();
      e += digits;
      b /= pow(10, digits);
    }
  }
  
  void bRound(int d) {
    b = round(b * (pow(10, d))) / pow(10, d);  
  }
  
  void bMult(float _b, int _e) {
    e += _e;
    b *= _b;
    validate();
  }
  
  void bMult(float x) {
    bMult(getBase(x) , getExpo(x));
  }
  
  void bMult(BigNum x) {
    bMult(x.b, x.e);
  }
  
  void bAdd(float _b, int _e) {
    int eDiff = abs(e - _e);
    println(_b, _e);
    if(eDiff > precision) {
      if(_e > e) {
         e = _e;
         if(_b > b) {
           b = _b;  
         }
      }
      return;
    }
    
    b *= pow(10, eDiff);
    b += _b;
    
    validate();
  }
  
  void bAdd(float x) {
    bAdd(getBase(x), getExpo(x));
  }
  
  int getBDigits() {
    return getExpo(b); 
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
  
  float toFloat() {
    return b * pow(10, e);  
  }
  
  int toInt() {
    return (int)toFloat();  
  }
}

int getExpo(float x) {
  int d = (int)Math.log10(abs(x)) * getSign(x);
  if(x < 1) {
    d--;  
  }
  return d;
}

float getBase(float x) {
  return x /= pow(10, getExpo(x));
}

int getSign(float x) {
  if(x < 0) {
    return -1; 
  } else {
    return 1;  
  }
}
