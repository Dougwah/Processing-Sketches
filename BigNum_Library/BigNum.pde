int precision = 7; // Maxmimum amount of decimals stored in a float
int displayPrecision = 2;

class BigNum {
  float b;
  int e;

  BigNum(float _b, int _e) {
    b = _b;
    e = _e;
    validate();
  }

  BigNum(float x) {
    e = getExpo(x);
    b = roundFloat(getBase(x), getAbs(e));
    validate();
  }
  
  BigNum(String x) {
    this(
      Float.valueOf(x.substring(0, x.toLowerCase().indexOf('e'))),
      Integer.valueOf(x.substring(x.toLowerCase().indexOf('e') + 1, x.length()))
    );
  }
  
  BigNum() {
    this(1, 0);
  }
  
  void validate() {
    if (b == 0) {
      e = 0;
      return;
    }

    int digits = getBDigits();
    
    if (b >= 10 || b < 1) {
      e += digits;
    }
    
    b = roundFloat(b * pow(10, -digits), precision);
  }
  
  BigNum bCopy() {
    return new BigNum(b, e);  
  }
  
  void bSet(BigNum x) {
    b = x.b;
    e = x.e;
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
    b = roundFloat(b, d);
    validate();
  }
  
  BigNum getRound(int d) {
    BigNum x = bCopy();
    x.setRound(d);
    return x;
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
    BigNum x = bCopy();
    x.setMult(_b, _e);
    return x;
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
    BigNum x = bCopy();
    x.setDiv(_b, _e);
    return x; 
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
    BigNum x = bCopy();
    x.setAdd(_b, _e);
    return x;
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
  
  BigNum getSub(float x) {
    return getSub(getBase(x), getExpo(x));  
  }
  
  BigNum getSub(BigNum x) {
    return getSub(x.b, x.e);
  }
  
  // == SQUARE ROOT ==
  
  BigNum getSqrt() {
    BigNum x = bCopy();
    x.setSqrt();
    return x;
  }
  
  void setSqrt() {
    b *= pow(10, e % 2);
    e = (e - e % 2) / 2;
    b = sqrt(b);
    validate();
  }
  
  // == POWER ==

  BigNum getPow(int p) {
    BigNum x = new BigNum();
    for(int i = 0; i < getAbs(p); i++) {
      if(p > 0) {
        x.setMult(this);
      } else {
        x.setDiv(this);
      }
    }
    return x;
  }
  
  void setPow(int p) {
    bSet(getPow(p));
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
    return b + "E" + e;
  }

  float toFloat() {
    return Float.valueOf(toStr());
  }

  int toInt() {
    return (int)toFloat();
  }
  
  // === FORMATTING ===
  
  String fRound() { // Scientific notation rounded to n decimal places
    BigNum x = getRound(displayPrecision);
    return trimFloat(x.b) + "e" + x.e;
  }
  
  String fTrim() { // Unrounded scientific notation with trailing .0 trimmed
     return trimFloat(b) + 'e' + e;
  }
  
  String fSmall() { // A regular float rounded to n places with trailing .0 trimmed
     BigNum x = getRound(constrain(e + displayPrecision, displayPrecision, precision));
     
     if(e >= precision) {
       return toStr();  
     }
     
     return trimFloat(x.toFloat());
  }
  
  String fSuffix() { // Rounded to 2 decimal places with a suffix, returns fSmall if less than 1000
    BigNum x = getRound(displayPrecision);
    if(x.e < 3 || x.e > suffixes.length * 3) {
      return fSmall();
    }

    return trimFloat(Float.valueOf(x.b + "E" + e % 3)) + suffixes[e / 3 - 1];
  }
  
}

// === HELPERS ===

float roundFloat(float x, int y) {
  int s = getSign(x);

  return round(getAbs(x) * pow(10, y)) / pow(10, y) * s;
}

// For removing trailing 0s
String trimFloat(float x) {
  String str = String.valueOf(x);

  if(str.substring(str.length() - 2, str.length()).equals(".0")) {
    str = str.substring(0, str.length() - 2);  
  }
  
  return str;
}

int getExpo(float x) {
  String str = "" + getAbs(x);
  int decimalIndex = str.indexOf('.');
  int eIndex = str.indexOf('E');

  if(eIndex != -1) {
    return Integer.valueOf(str.substring(eIndex + 1, str.length()));
  }

  if(getAbs(x) >= 1) {
    return str.substring(0, decimalIndex).length() - 1;
  } else {
    return -str.substring(decimalIndex + 1, str.length()).length();
  }

  //double e = Math.log10(getAbs(x));
  //if (getAbs(x) < 1) {
  //  e--;
  //}
  
  //return (int)e;
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

String[] suffixes = {
  "K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No", // 1e30

  "De","UDe", "DDe", "TDe", "QdDe", "QnDe", "SxDe", "SpDe", "OcDe", "NoDe", // 1e60
  "Vg", "UVg", "DVg", "TVg", "QdVg", "QnVg", "SxVg", "SpVg", "OcVg", "NoVg",
  "Tg", "UTg", "DTg", "TTg", "QdTg", "QnTg", "SxTg", "SpTg", "OcTg", "NoTg",
  "Qdg", "UQdg", "DQdg", "TQdg", "QdQdg", "QnQdg", "SxQdg", "SpQdg", "OcQdg", "NoQdg",
  "Qng", "UQng", "DQng", "TQng", "QdQng", "QnQng", "SxQng", "SpQng", "OcQng", "NoQng",
  "Sxg", "USxg", "DSxg", "TSxg", "QdSxg", "QnSxg", "SxSxg", "SpSxg", "OcSxg", "NoSxg",
  "Spg", "USpg", "DSpg", "TSpg", "QdSpg", "QnSpg", "SxSpg", "SpSpg", "OcSpg", "NoSpg",
  "Ocg", "UOcg", "DOcg", "TOcg", "QdOcg", "QnOcg", "SxOcg", "SpOcg", "OcOcg", "NoOcg",
  "Nog", "UNog", "DNog", "TNog", "QdNog", "QnNog", "SxNog", "SpNog", "OcNog", "NoNog", // 1e300

  "Ce", "UCe", "DCe", "TCe", "QdCe", "QnCe", "SxCe", "SpCe", "OcCe", "NoCe",
  "DeCe", "UDeCe", "DDeCe","TDeCe", "QdDeCe", "QnDeCe", "SxDeCe", "SpDeCe", "OcDeCe", "NoDeCe",
  "VgCe", "UVgCe", "DVgCe", "TVgCe", "QdVgCe", "QnVgCe", "SxVgCe", "SpVgCe", "OcVgCe", "NoVgCe",
  "TgCe", "UTgCe", "DTgCe", "TTgCe", "QdTgCe", "QnTgCe", "SxTgCe", "SpTgCe", "OcTgCe", "NoTgCe",
  "QdgCe", "UQdgCe", "DQdgCe", "TQdgCe", "QdQdgCe", "QnQdgCe", "SxQdgCe", "SpQdgCe", "OcQdgCe", "NoQdgCe",
  "QngCe", "UQngCe", "DQngCe", "TQngCe", "QdQngCe", "QnQngCe", "SxQngCe", "SpQngCe", "OcQngCe", "NoQngCe",
  "SxgCe", "USxgCe", "DSxgCe", "TSxgCe", "QdSxgCe", "QnSxgCe", "SxSxgCe", "SpSxgCe", "OcSxgCe", "NoSxgCe",  
  "SpgCe", "USpgCe", "DSpgCe", "TSpgCe", "QdSpgCe", "QnSpgCe", "SxSpgCe", "SpSpgCe", "OcSpgCe", "NoSpgCe",
  "OcgCe", "UOcgCe", "DOcgCe", "TOcgCe", "QdOcgCe", "QnOcgCe", "SxOcgCe", "SpOcgCe", "OcOcgCe", "NoOcgCe",
  "NogCe", "UNogCe", "DNogCe", "TNogCe", "QdNogCe", "QnNogCe", "SxNogCe", "SpNogCe", "OcNogCe", "NoNogCe", // 1e600
  
  "DuCe", "UDuCe", "DDuCe", "TDuCe", "QdDuCe", "QnDuCe", "SxDuCe", "SpDuCe", "OcDuCe", "NoDuCe",
  "DeDuCe", "UDeDuCe", "DDeDuCe", "TDeDuCe", "QdDeDuCe", "QnDeDuCe", "SxDeDuCe", "SpDeDuCe", "OcDeDuCe", "NoDeDuCe", 
  "VgDuCe", "UVgDuCe", "DVgDuCe", "TVgDuCe", "QdVgDuCe", "QnVgDuCe", "SxVgDuCe", "SpVgDuCe", "OcVgDuCe", "NoVgDuCe",
  "TgDuCe", "UTgDuCe", "DTgDuCe", "TTgDuCe", "QdTgDuCe", "QnTgDuCe", "SxTgDuCe", "SpTgDuCe", "OcTgDuCe", "NoTgDuCe",
  "QdgDuCe", "UQdgDuCe", "DQdgDuCe", "TQdgDuCe", "QdQdgDuCe", "QnQdgDuCe", "SxQdgDuCe", "SpQdgDuCe", "OcQdgDuCe", "NoQdgDuCe",
  "QngDuCe", "UQngDuCe", "DQngDuCe", "TQngDuCe", "QdQngDuCe", "QnQngDuCe", "SxQngDuCe", "SpQngDuCe", "OcQngDuCe", "NoQngDuCe",
  "SxgDuCe", "USxgDuCe", "DSxgDuCe", "TSxgDuCe", "QdSxgDuCe", "QnSxgDuCe", "SxSxgDuCe", "SpSxgDuCe", "OcSxgDuCe", "NoSxgDuCe",  
  "SpgDuCe", "USpgDuCe", "DSpgDuCe", "TSpgDuCe", "QdSpgDuCe", "QnSpgDuCe", "SxSpgDuCe", "SpSpgDuCe", "OcSpgDuCe", "NoSpgDuCe",
  "OcgDuCe", "UOcgDuCe", "DOcgDuCe", "TOcgDuCe", "QdOcgDuCe", "QnOcgDuCe", "SxOcgDuCe", "SpOcgDuCe", "OcOcgDuCe", "NoOcgDuCe",
  "NogDuCe", "UNogDuCe", "DNogDuCe", "TNogDuCe", "QdNogDuCe", "QnNogDuCe", "SxNogDuCe", "SpNogDuCe", "OcNogDuCe", "NoNogDuCe", // 1e900

  "TuCe", "UTuCe", "DTuCe", "TTuCe", "QdTuCe", "QnTuCe", "SxTuCe", "SpTuCe", "OcTuCe", "NoTuCe",
  "DeTuCe", "UDeTuCe", "DDeTuCe", "TDeTuCe", "QdDeTuCe", "QnDeTuCe", "SxDeTuCe", "SpDeTuCe", "OcDeTuCe", "NoDeTuCe",
  "VgTuCe", "UVgTuCe", "DVgTuCe", "TVgTuCe", "QdVgTuCe", "QnVgTuCe", "SxVgTuCe", "SpVgTuCe", "OcVgTuCe", "NoVgTuCe",
  "TgTuCe", "UTgTuCe", "DTgTuCe", "TTgTuCe", "QdTgTuCe", "QnTgTuCe", "SxTgTuCe", "SpTgTuCe", "OcTgTuCe", "NoTgTuCe",
  "QdgTuCe", "UQdgTuCe", "DQdgTuCe", "TQdgTuCe", "QdQdgTuCe", "QnQdgTuCe", "SxQdgTuCe", "SpQdgTuCe", "OcQdgTuCe", "NoQdgTuCe",
  "QngTuCe", "UQngTuCe", "DQngTuCe", "TQngTuCe", "QdQngTuCe", "QnQngTuCe", "SxQngTuCe", "SpQngTuCe", "OcQngTuCe", "NoQngTuCe",
  "SxgTuCe", "USxgTuCe", "DSxgTuCe", "TSxgTuCe", "QdSxgTuCe", "QnSxgTuCe", "SxSxgTuCe", "SpSxgTuCe", "OcSxgTuCe", "NoSxgTuCe",  
  "SpgTuCe", "USpgTuCe", "DSpgTuCe", "TSpgTuCe", "QdSpgTuCe", "QnSpgTuCe", "SxSpgTuCe", "SpSpgTuCe", "OcSpgTuCe", "NoSpgTuCe",
  "OcgTuCe", "UOcgTuCe", "DOcgTuCe", "TOcgTuCe", "QdOcgTuCe", "QnOcgTuCe", "SxOcgTuCe", "SpOcgTuCe", "OcOcgTuCe", "NoOcgTuCe",
  "NogTuCe", "UNogTuCe", "DNogTuCe", "TNogTuCe", "QdNogTuCe", "QnNogTuCe", "SxNogTuCe", "SpNogTuCe", "OcNogTuCe", "NoNogTuCe", // 1e1200
  
  "QdGe", "UQdGe", "DQdGe", "TQdGe", "QdQdGe", "QnQdGe", "SxQdGe", "SpQdGe", "OcQdGe", "NoQdGe",
  "DeQdGe", "UDeQdGe", "DDeQdGe", "TDeQdGe", "QdDeQdGe", "QnDeQdGe", "SxDeQdGe", "SpDeQdGe", "OcDeQdGe", "NoDeQdGe",
  "VgQdGe", "UVgQdGe", "DVgQdGe", "TVgQdGe", "QdVgQdGe", "QnVgQdGe", "SxVgQdGe", "SpVgQdGe", "OcVgQdGe", "NoVgQdGe",
  "TgQdGe", "UTgQdGe", "DTgQdGe", "TTgQdGe", "QdTgQdGe", "QnTgQdGe", "SxTgQdGe", "SpTgQdGe", "OcTgQdGe", "NoTgQdGe",
  "QdgQdGe", "UQdgQdGe", "DQdgQdGe", "TQdgQdGe", "QdQdgQdGe", "QnQdgQdGe", "SxQdgQdGe", "SpQdgQdGe", "OcQdgQdGe", "NoQdgQdGe",
  "QngQdGe", "UQngQdGe", "DQngQdGe", "TQngQdGe", "QdQngQdGe", "QnQngQdGe", "SxQngQdGe", "SpQngQdGe", "OcQngQdGe", "NoQngQdGe",
  "SxgQdGe", "USxgQdGe", "DSxgQdGe", "TSxgQdGe", "QdSxgQdGe", "QnSxgQdGe", "SxSxgQdGe", "SpSxgQdGe", "OcSxgQdGe", "NoSxgQdGe",  
  "SpgQdGe", "USpgQdGe", "DSpgQdGe", "TSpgQdGe", "QdSpgQdGe", "QnSpgQdGe", "SxSpgQdGe", "SpSpgQdGe", "OcSpgQdGe", "NoSpgQdGe",
  "OcgQdGe", "UOcgQdGe", "DOcgQdGe", "TOcgQdGe", "QdOcgQdGe", "QnOcgQdGe", "SxOcgQdGe", "SpOcgQdGe", "OcOcgQdGe", "NoOcgQdGe",
  "NogQdGe", "UNogQdGe", "DNogQdGe", "TNogQdGe", "QdNogQdGe", "QnNogQdGe", "SxNogQdGe", "SpNogQdGe", "OcNogQdGe", "NoNogQdGe", // 1e1500
  
  "QnGe", "UQnGe", "DQnGe", "TQnGe", "QdQnGe", "QnQnGe", "SxQnGe", "SpQnGe", "OcQnGe", "NoQnGe",
  "DeQnGe", "UDeQnGe", "DDeQnGe", "TDeQnGe", "QdDeQnGe", "QnDeQnGe", "SxDeQnGe", "SpDeQnGe", "OcDeQnGe", "NoDeQnGe",
  "VgQnGe", "UVgQnGe", "DVgQnGe", "TVgQnGe", "QdVgQnGe", "QnVgQnGe", "SxVgQnGe", "SpVgQnGe", "OcVgQnGe", "NoVgQnGe",
  "TgQnGe", "UTgQnGe", "DTgQnGe", "TTgQnGe", "QdTgQnGe", "QnTgQnGe", "SxTgQnGe", "SpTgQnGe", "OcTgQnGe", "NoTgQnGe",
  "QdgQnGe", "UQdgQnGe", "DQdgQnGe", "TQdgQnGe", "QdQdgQnGe", "QnQdgQnGe", "SxQdgQnGe", "SpQdgQnGe", "OcQdgQnGe", "NoQdgQnGe",
  "QngQnGe", "UQngQnGe", "DQngQnGe", "TQngQnGe", "QdQngQnGe", "QnQngQnGe", "SxQngQnGe", "SpQngQnGe", "OcQngQnGe", "NoQngQnGe",
  "SxgQnGe", "USxgQnGe", "DSxgQnGe", "TSxgQnGe", "QdSxgQnGe", "QnSxgQnGe", "SxSxgQnGe", "SpSxgQnGe", "OcSxgQnGe", "NoSxgQnGe",  
  "SpgQnGe", "USpgQnGe", "DSpgQnGe", "TSpgQnGe", "QdSpgQnGe", "QnSpgQnGe", "SxSpgQnGe", "SpSpgQnGe", "OcSpgQnGe", "NoSpgQnGe",
  "OcgQnGe", "UOcgQnGe", "DOcgQnGe", "TOcgQnGe", "QdOcgQnGe", "QnOcgQnGe", "SxOcgQnGe", "SpOcgQnGe", "OcOcgQnGe", "NoOcgQnGe",
  "NogQnGe", "UNogQnGe", "DNogQnGe", "TNogQnGe", "QdNogQnGe", "QnNogQnGe", "SxNogQnGe", "SpNogQnGe", "OcNogQnGe", "NoNogQnGe", // 1e1800
  
  "SxGe", "USxGe", "DSxGe", "TSxGe", "QdSxGe", "QnSxGe", "SxSxGe", "SpSxGe", "OcSxGe", "NoSxGe",
  "DeSxGe", "UDeSxGe", "DDeSxGe", "TDeSxGe", "QdDeSxGe", "QnDeSxGe", "SxDeSxGe", "SpDeSxGe", "OcDeSxGe", "NoDeSxGe",
  "VgSxGe", "UVgSxGe", "DVgSxGe", "TVgSxGe", "QdVgSxGe", "QnVgSxGe", "SxVgSxGe", "SpVgSxGe", "OcVgSxGe", "NoVgSxGe",
  "TgSxGe", "UTgSxGe", "DTgSxGe", "TTgSxGe", "QdTgSxGe", "QnTgSxGe", "SxTgSxGe", "SpTgSxGe", "OcTgSxGe", "NoTgSxGe",
  "QdgSxGe", "UQdgSxGe", "DQdgSxGe", "TQdgSxGe", "QdQdgSxGe", "QnQdgSxGe", "SxQdgSxGe", "SpQdgSxGe", "OcQdgSxGe", "NoQdgSxGe",
  "QngSxGe", "UQngSxGe", "DQngSxGe", "TQngSxGe", "QdQngSxGe", "QnQngSxGe", "SxQngSxGe", "SpQngSxGe", "OcQngSxGe", "NoQngSxGe",
  "SxgSxGe", "USxgSxGe", "DSxgSxGe", "TSxgSxGe", "QdSxgSxGe", "QnSxgSxGe", "SxSxgSxGe", "SpSxgSxGe", "OcSxgSxGe", "NoSxgSxGe",  
  "SpgSxGe", "USpgSxGe", "DSpgSxGe", "TSpgSxGe", "QdSpgSxGe", "QnSpgSxGe", "SxSpgSxGe", "SpSpgSxGe", "OcSpgSxGe", "NoSpgSxGe",
  "OcgSxGe", "UOcgSxGe", "DOcgSxGe", "TOcgSxGe", "QdOcgSxGe", "QnOcgSxGe", "SxOcgSxGe", "SpOcgSxGe", "OcOcgSxGe", "NoOcgSxGe",
  "NogSxGe", "UNogSxGe", "DNogSxGe", "TNogSxGe", "QdNogSxGe", "QnNogSxGe", "SxNogSxGe", "SpNogSxGe", "OcNogSxGe", "NoNogSxGe", // 1e2100
  
  "SpGe", "USpGe", "DSpGe", "TSpGe", "QdSpGe", "QnSpGe", "SxSpGe", "SpSpGe", "OcSpGe", "NoSpGe",
  "DeSpGe", "UDeSpGe", "DDeSpGe", "TDeSpGe", "QdDeSpGe", "QnDeSpGe", "SxDeSpGe", "SpDeSpGe", "OcDeSpGe", "NoDeSpGe",
  "VgSpGe", "UVgSpGe", "DVgSpGe", "TVgSpGe", "QdVgSpGe", "QnVgSpGe", "SxVgSpGe", "SpVgSpGe", "OcVgSpGe", "NoVgSpGe",
  "TgSpGe", "UTgSpGe", "DTgSpGe", "TTgSpGe", "QdTgSpGe", "QnTgSpGe", "SxTgSpGe", "SpTgSpGe", "OcTgSpGe", "NoTgSpGe",
  "QdgSpGe", "UQdgSpGe", "DQdgSpGe", "TQdgSpGe", "QdQdgSpGe", "QnQdgSpGe", "SxQdgSpGe", "SpQdgSpGe", "OcQdgSpGe", "NoQdgSpGe",
  "QngSpGe", "UQngSpGe", "DQngSpGe", "TQngSpGe", "QdQngSpGe", "QnQngSpGe", "SxQngSpGe", "SpQngSpGe", "OcQngSpGe", "NoQngSpGe",
  "SxgSpGe", "USxgSpGe", "DSxgSpGe", "TSxgSpGe", "QdSxgSpGe", "QnSxgSpGe", "SxSxgSpGe", "SpSxgSpGe", "OcSxgSpGe", "NoSxgSpGe",  
  "SpgSpGe", "USpgSpGe", "DSpgSpGe", "TSpgSpGe", "QdSpgSpGe", "QnSpgSpGe", "SxSpgSpGe", "SpSpgSpGe", "OcSpgSpGe", "NoSpgSpGe",
  "OcgSpGe", "UOcgSpGe", "DOcgSpGe", "TOcgSpGe", "QdOcgSpGe", "QnOcgSpGe", "SxOcgSpGe", "SpOcgSpGe", "OcOcgSpGe", "NoOcgSpGe",
  "NogSpGe", "UNogSpGe", "DNogSpGe", "TNogSpGe", "QdNogSpGe", "QnNogSpGe", "SxNogSpGe", "SpNogSpGe", "OcNogSpGe", "NoNogSpGe", // 1e2400
  
  "OcGe", "UOcGe", "DOcGe", "TOcGe", "QdOcGe", "QnOcGe", "SxOcGe", "SpOcGe", "OcOcGe", "NoOcGe",
  "DeOcGe", "UDeOcGe", "DDeOcGe", "TDeOcGe", "QdDeOcGe", "QnDeOcGe", "SxDeOcGe", "SpDeOcGe", "OcDeOcGe", "NoDeOcGe",
  "VgOcGe", "UVgOcGe", "DVgOcGe", "TVgOcGe", "QdVgOcGe", "QnVgOcGe", "SxVgOcGe", "SpVgOcGe", "OcVgOcGe", "NoVgOcGe",
  "TgOcGe", "UTgOcGe", "DTgOcGe", "TTgOcGe", "QdTgOcGe", "QnTgOcGe", "SxTgOcGe", "SpTgOcGe", "OcTgOcGe", "NoTgOcGe",
  "QdgOcGe", "UQdgOcGe", "DQdgOcGe", "TQdgOcGe", "QdQdgOcGe", "QnQdgOcGe", "SxQdgOcGe", "SpQdgOcGe", "OcQdgOcGe", "NoQdgOcGe",
  "QngOcGe", "UQngOcGe", "DQngOcGe", "TQngOcGe", "QdQngOcGe", "QnQngOcGe", "SxQngOcGe", "SpQngOcGe", "OcQngOcGe", "NoQngOcGe",
  "SxgOcGe", "USxgOcGe", "DSxgOcGe", "TSxgOcGe", "QdSxgOcGe", "QnSxgOcGe", "SxSxgOcGe", "SpSxgOcGe", "OcSxgOcGe", "NoSxgOcGe",  
  "SpgOcGe", "USpgOcGe", "DSpgOcGe", "TSpgOcGe", "QdSpgOcGe", "QnSpgOcGe", "SxSpgOcGe", "SpSpgOcGe", "OcSpgOcGe", "NoSpgOcGe",
  "OcgOcGe", "UOcgOcGe", "DOcgOcGe", "TOcgOcGe", "QdOcgOcGe", "QnOcgOcGe", "SxOcgOcGe", "SpOcgOcGe", "OcOcgOcGe", "NoOcgOcGe",
  "NogOcGe", "UNogOcGe", "DNogOcGe", "TNogOcGe", "QdNogOcGe", "QnNogOcGe", "SxNogOcGe", "SpNogOcGe", "OcNogOcGe", "NoNogOcGe", // 1e2700

  "NoGe", "UNoGe", "DNoGe", "TNoGe", "QdNoGe", "QnNoGe", "SxNoGe", "SpNoGe", "OcNoGe", "NoNoGe",
  "DeNoGe", "UDeNoGe", "DDeNoGe", "TDeNoGe", "QdDeNoGe", "QnDeNoGe", "SxDeNoGe", "SpDeNoGe", "OcDeNoGe", "NoDeNoGe",
  "VgNoGe", "UVgNoGe", "DVgNoGe", "TVgNoGe", "QdVgNoGe", "QnVgNoGe", "SxVgNoGe", "SpVgNoGe", "OcVgNoGe", "NoVgNoGe",
  "TgNoGe", "UTgNoGe", "DTgNoGe", "TTgNoGe", "QdTgNoGe", "QnTgNoGe", "SxTgNoGe", "SpTgNoGe", "OcTgNoGe", "NoTgNoGe",
  "QdgNoGe", "UQdgNoGe", "DQdgNoGe", "TQdgNoGe", "QdQdgNoGe", "QnQdgNoGe", "SxQdgNoGe", "SpQdgNoGe", "OcQdgNoGe", "NoQdgNoGe",
  "QngNoGe", "UQngNoGe", "DQngNoGe", "TQngNoGe", "QdQngNoGe", "QnQngNoGe", "SxQngNoGe", "SpQngNoGe", "OcQngNoGe", "NoQngNoGe",
  "SxgNoGe", "USxgNoGe", "DSxgNoGe", "TSxgNoGe", "QdSxgNoGe", "QnSxgNoGe", "SxSxgNoGe", "SpSxgNoGe", "OcSxgNoGe", "NoSxgNoGe",  
  "SpgNoGe", "USpgNoGe", "DSpgNoGe", "TSpgNoGe", "QdSpgNoGe", "QnSpgNoGe", "SxSpgNoGe", "SpSpgNoGe", "OcSpgNoGe", "NoSpgNoGe",
  "OcgNoGe", "UOcgNoGe", "DOcgNoGe", "TOcgNoGe", "QdOcgNoGe", "QnOcgNoGe", "SxOcgNoGe", "SpOcgNoGe", "OcOcgNoGe", "NoOcgNoGe",
  "NogNoGe", "UNogNoGe", "DNogNoGe", "TNogNoGe", "QdNogNoGe", "QnNogNoGe", "SxNogNoGe", "SpNogNoGe", "OcNogNoGe", "NoNogNoGe", // 1e3000
  "Mi"
};

// Attempting to mimic math library functions, Has precision errors

//float calcSqrt(float x) {
//  return calcRoot(x, 2);
//}

//// What number must be multiplied together y times to equal x
//float calcRoot(float x, int y) {
//  float high = x;
//  float low = 1;
//  float mid = 0;
  
//  for(int i = 0; i < 100; i++) {
//    mid = (high + low) * 0.5;

//    if(calcPow(mid, y) > x) {
//      high = mid;  
//    } else {
//      low = mid;
//    }
//  }

//  return mid;
//}

////Finding a decimal root y of x is equivalent to raising x to the power of y
//float calcRoot(float x, float y) {
//  return calcPow(x, y);
//}

////Number multiplied by itself y times
//float calcPow(float x, int y) {
//  float result = 1;
//  for(int i = 0; i < getAbs(y); i++) {
//    if(y > 0) {
//      result *= x;    
//    } else {
//      result /= x;
//    }
//  }
//  return result;
//}

////Make the exponent a whole number by multiplying it by it 10 to the power of its figures
////find the root of x to the exponent
////return the root of x to the power of y * its exponent
//float calcPow(float base, float expo) {
  
//  int digits = (int)calcPow(10, getDecimals(expo));
//  println(digits);
//  float root = calcRoot(base, digits);
 
//  println(pow(pow(base, 1.0 / digits), (int)(expo * digits)));
//  return calcPow(root, (int)(expo * digits));  
//}

//int getDecimals(float x) {
//  String y = String.valueOf(x);
//  return y.substring(y.indexOf('.') + 1).length();
//}

//float trimDecimal(float x, int y) {
//  println(getDecimals(x));
//  if(getDecimals(x) > y) {
//    return Float.valueOf(String.valueOf(x).substring(0, y + 2));  
//  }
//  return x;
//}
