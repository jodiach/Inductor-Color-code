class UnitConverter {
  static String formatInductance(double valueInMicroHenry) {
    if (valueInMicroHenry >= 1000000) {
      return '${(valueInMicroHenry / 1000000).toStringAsFixed(2)} H';
    } else if (valueInMicroHenry >= 1000) {
      return '${(valueInMicroHenry / 1000).toStringAsFixed(2)} mH';
    } else if (valueInMicroHenry >= 1) {
      return '${valueInMicroHenry.toStringAsFixed(2)} µH';
    } else if (valueInMicroHenry >= 0.001) {
      return '${(valueInMicroHenry * 1000).toStringAsFixed(2)} nH';
    } else {
      return '${(valueInMicroHenry * 1000000).toStringAsFixed(2)} pH';
    }
  }

  static String getBestUnit(double valueInMicroHenry) {
    if (valueInMicroHenry >= 1000000) return 'H';
    if (valueInMicroHenry >= 1000) return 'mH';
    if (valueInMicroHenry >= 1) return 'µH';
    if (valueInMicroHenry >= 0.001) return 'nH';
    return 'pH';
  }
}
