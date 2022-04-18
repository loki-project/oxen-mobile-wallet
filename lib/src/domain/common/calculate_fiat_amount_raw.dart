String calculateFiatAmountRaw({required double? price, required double cryptoAmount}) {
  final result = (price ?? 0.0) * cryptoAmount;

  if (result == 0.0) {
    return '0.00';
  }

  return result > 0.01 ? result.toStringAsFixed(2) : '< 0.01';
}
