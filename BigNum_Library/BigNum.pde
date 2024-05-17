int precision = 6; // Maxmimum amount of decimals stored in a float

class BigNum {
  float b;
  int e;

  BigNum(float _b, int _e) {
    b = _b;
    e = _e;
    validate();
  }

  BigNum(float x) {
    this(getBase(x), getExpo(x));  
  }
  
  BigNum(String x) {
    this(
      Float.valueOf(x.substring(0, x.toLowerCase().indexOf('e'))),
      Integer.valueOf(x.substring(x.toLowerCase().indexOf('e') + 1, x.length()))
    );
  }
  
  void validate() {
    if (b == 0) {
      e = 0;
      return;
    }

   
    if (b >= 10 || b < 1) {
      int digits = getBDigits();
      e += digits;
      b = roundDecimal(b * pow(10, -digits), precision);
    }
  }
  
  BigNum bCopy() {
    return new BigNum(b, e);  
  }
  
  // === COMPARISON ===
  
  // == EQUALS ==
  
  boolean equalTo(float _b, int _e) {
    return e == _e && b == _b;  
  }
  
  boolean equalTo(float x) {
    return equalTo(getBase(x), getExpo(x));  
  }
  
  boolean equalTo(BigNum x) {
    return equalTo(x.b, x.e);  
  }
  
  // == GREATER THAN ==
  
  boolean greaterThan(float _b, int _e) {
    return e > _e || e == _e && b > _b;  
  }
  
  boolean greaterThan(float x) {
    return greaterThan(getBase(x), getExpo(x)); 
  }
  
  boolean greaterThan(BigNum x) {
    return greaterThan(x.b, x.e);  
  }
  
  // == GREATER THAN OR EQUAL TO
  
  boolean greaterThanEqual(float _b, int _e) {
    return greaterThan(_b, _e) || equalTo(_b, _e);
  }
  
  boolean greaterThanEqual(float x) {
    return greaterThan(getBase(x), getExpo(x));  
  }
  
  boolean greaterThanEqual(BigNum x) {
    return greaterThan(x.b, x.e); 
  }
  
  // == lESS THAN ==
  
  boolean lessThan(float _b, int _e) {
    return !greaterThanEqual(_b, _e);  
  }
  
  boolean lessThan(float x) {
    return lessThan(getBase(x), getExpo(x));  
  }
  
  boolean lessThan(BigNum x) {
    return lessThan(x.b, x.e);  
  }
  
  // == LESS THAN OR EQUAL TO
  
  boolean lessThanEqual(float _b, int _e) {
    return !greaterThan(_b, _e) || equalTo(_b, _e);  
  }
  
  boolean lessThanEqual(float x) {
    return lessThanEqual(getBase(x), getExpo(x));  
  }
  
  boolean lessThanEqual(BigNum x) {
    return lessThanEqual(x.b, x.e);  
  }
  
  // === ARITHMETIC ===
  
  // == GENERAL ==
  
  void setAbs() {
    b *= getBSign();  
  }
  
  void setRound(int d) {
    b = roundDecimal(b, d);
  }
  
  // == MULTIPLY ==
  
  // = SET =
  
  void setMult(float _b, int _e) {
    e += _e;
    b *= _b;
    validate();
  }

  void setMult(float x) {
    setMult(getBase(x), getExpo(x));
  }

  void setMult(BigNum x) {
    setMult(x.b, x.e);
  }
  
  // = GET =
  
  BigNum getMult(float _b, int _e) {
    return new BigNum(b * _b, e + _e);  
  }
  
  BigNum getMult(float x) {
    return getMult(getBase(x), getExpo(e)); 
  }
  
  BigNum getMult(BigNum x) {
    return getMult(x.b, x.e);  
  }
  
  // == DIVIDE ==
  
  // = SET =
  
  void setDiv(float _b, int _e) {
    e -= _e;
    b /= _b;
    validate();
  }
  
  void setDiv(float x) {
    setDiv(getBase(x), getExpo(x));  
  }
  
  void setDiv(BigNum x) {
    setDiv(x.b, x.e);  
  }
  
  // = GET =
  
  BigNum getDiv(float _b, int _e) {
    return new BigNum(b / _b, e - _e);  
  }
  
  BigNum getDiv(float x) {
    return getDiv(getBase(x), getExpo(e)); 
  }
  
  BigNum getDiv(BigNum x) {
    return getDiv(x.b, x.e);  
  }
  
  // == ADD ==
  
  // = SET =

  void setAdd(float _b, int _e) {
    if (!checkPrecision(_e)) {
      if(_e > e) {
        e = _e;
        b = _b;
      }
      return;
    }
    
    _b *= pow(10, -(e - _e));
    b += _b;

    validate();
  }

  void setAdd(float x) {
    setAdd(getBase(x), getExpo(x));
  }
  
  void setAdd(BigNum x) {
    setAdd(x.b, x.e);
  }
  
  // = GET =
  
  BigNum getAdd(float _b, int _e) {
    if (!checkPrecision(_e)) {
      if(_e > e) {
        return new BigNum(_b, _e);
      }
      return bCopy();
    }
    
    return new BigNum(b + (_b * pow(10, -(e - _e))), e);
  }
  
  BigNum getAdd(float x) {
    return getAdd(getBase(x), getExpo(x));  
  }
  
  BigNum getAdd(BigNum x) {
    return getAdd(x.b, x.e);  
  }
  
  // == SUBTRACT ==
  
  // = SET =
  
  void setSub(float _b, int _e) {
    setAdd(- _b, _e);  
  }
  
  void setSub(float x) {
    setSub(getBase(x), getExpo(x));  
  }
  
  void setSub(BigNum x) {
    setSub(x.b, x.e);  
  }
  
  // = GET =
  
  BigNum getSub(float _b, int _e) {
    return getAdd(-_b, _e);  
  }
  
  // == SQUARE ROOT ==
  
  BigNum getSqrt() {
    return new BigNum(calcSqrt(b * pow(10, e % 2)), (e - e % 2) / 2);  
  }
  
  void setSqrt() {
    b *= pow(10, e % 2);
    e = (e - e % 2) / 2;
    b = calcSqrt(b);
    validate();
  }
  
  // === HELPERS ===
  
  boolean checkPrecision(int _e) {
    if (getAbs(e - _e) > precision) {
      return false;
    }
    return true;
  }

  int getBDigits() {
    return getExpo(b);
  }

  int getESign() {
    return getSign(e);
  }

  int getBSign() {
    return getSign(b);
  }
  
  // === CASTING ===

  String toStr() {
    return String.valueOf(b) + "E" + String.valueOf(e);
  }

  float toFloat() {
    return b * pow(10, e);
  }

  int toInt() {
    return (int)toFloat();
  }
}

// === HELPERS ===

int getDecimals(float x) {
  String y = String.valueOf(x);
  return y.substring(y.indexOf('.') + 1).length();
}

float trimDecimal(float x, int y) {
  if(getDecimals(x) > y) {
    return Float.valueOf(String.valueOf(x).substring(0, y + 2));  
  }
  return x;
}

float roundDecimal(float x, int y) {
  int s = getSign(x);
  return round(getAbs(x) * (pow(10, y))) / pow(10, y) * s;
}

int getExpo(float x) {
  int d = (int)Math.log10(getAbs(x));
  if (getAbs(x) < 1) {
    d--;
  }
  return d;
}

float getBase(float x) {
  int s = getSign(x);
  return x = getAbs(x) / pow(10, getExpo(x)) * s;
}

int getSign(float x) {
  if (x < 0) {
    return -1;
  } else {
    return 1;
  }
}

int getSign(double x) {
  if (x < 0) {
    return -1;
  } else {
    return 1;
  }
}

int getAbs(int x) {
  return x * getSign(x);  
}

float getAbs(float x) {
  return x * getSign(x);  
}

double getAbs(double x) {
  return x * getSign(x);
}

float calcSqrt(float x) {
  return calcRoot(x, 2);
}

// What number must be multiplied together y times to equal x
float calcRoot(float x, int y) {
  float high = x;
  float low = 1;
  float mid = 0;
  
  for(int i = 0; i < 100; i++) {
    mid = (high + low) * 0.5;

    if(calcPow(mid, y) > x) {
      high = mid;  
    } else {
      low = mid;
    }
  }

  return mid;
}

//Finding a decimal root y of x is equivalent to raising x to the power of y
float calcRoot(float x, float y) {
  return calcPow(x, y);  
}

//Number multiplied by itself y times
float calcPow(float x, int y) {
  float result = 1;
  for(int i = 0; i < getAbs(y); i++) {
    if(y > 0) {
      result *= x;    
    } else {
      result /= x;
    }
  }
  return result;
}

//Make the exponent a whole number by multiplying it by it 10 to the power of its figures
//find the root of x to the exponent
//return the root of x to the power of y * its exponent
float calcPow(float base, float expo) {
  
  int digits = (int)calcPow(10, getDecimals(expo));
  println(digits);
  float root = calcRoot(base, digits);
 
  println(pow(pow(base, 1.0 / digits), (int)(expo * digits)));
  return calcPow(root, (int)(expo * digits));  
}
