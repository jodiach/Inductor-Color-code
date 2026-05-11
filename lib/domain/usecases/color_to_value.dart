
class ColorToValue {
  static double calculate(List<int> digits, double multiplier) {
    if (digits.isEmpty) return 0;
    
    int combinedDigits = 0;
    for (int digit in digits) {
      combinedDigits = combinedDigits * 10 + digit;
    }
    
    return combinedDigits * multiplier;
  }
}
