class InvestmentCalculator {
  static double calculateReturns(double amount, double interest) {
    return amount * interest / 100;
  }

  static double calculateReturnsPercentage(double returns, double amount) {
    if (amount == 0) return 0;
    return (returns / amount) * 100;
  }

  static double calculateCurrentBalance({
    required double amount,
    required double interest,
    DateTime? startDate,
    int? durationInMonths,
    bool isRecurring = false,
  }) {
    if (startDate == null || durationInMonths == null) return amount;

    final now = DateTime.now();
    final monthsElapsed = now.difference(startDate).inDays / 30;
    final actualMonths = monthsElapsed.floor();

    if (isRecurring) {
      // For recurring deposits
      final monthlyDeposit = amount;
      double balance = 0;

      // Calculate balance with compound interest for each monthly deposit
      for (int i = 0; i < actualMonths; i++) {
        final remainingMonths = actualMonths - i;
        final deposit = monthlyDeposit;
        final interestAmount =
            (deposit * interest * remainingMonths) / (12 * 100);
        balance += deposit + interestAmount;
      }

      return balance;
    } else {
      // For fixed deposits
      final interestAmount = (amount * interest * actualMonths) / (12 * 100);
      return amount + interestAmount;
    }
  }

  static double calculateXIRR(
      List<double> amounts, List<double> interests, double totalInvestment) {
    if (totalInvestment == 0) return 0;

    double weightedSum = 0;
    for (int i = 0; i < amounts.length; i++) {
      weightedSum += (amounts[i] / totalInvestment * interests[i]);
    }

    return weightedSum;
  }

  static double calculateAbsoluteReturns(
      double totalReturns, double totalInvestment) {
    if (totalInvestment == 0) return 0;
    return (totalReturns / totalInvestment) * 100;
  }
}
