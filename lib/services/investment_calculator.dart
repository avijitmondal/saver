import 'dart:math';

class InvestmentCalculator {
  // Fixed Deposit: Compound Interest
  // compoundingPerYear is derived from Investment.compoundingFrequency:
  // quarterly => 4, half-yearly/semi-annually => 2, yearly/annual => 1, monthly => 12 (future support)
  // Unknown values fall back to 4 (quarterly) for a sensible default.
  static double calculateReturns(double amount, double interest, {int? durationInMonths, int compoundingPerYear = 4}) {
    if (durationInMonths == null || durationInMonths <= 0) {
      return amount * interest / 100;
    }
    
    try {
      double years = durationInMonths / 12.0;
      double rate = interest / 100.0;
      double n = compoundingPerYear.toDouble();
      double maturity = amount * (pow(1 + rate / n, n * years));
      
      // Check for invalid values
      if (maturity.isNaN || maturity.isInfinite) {
        return amount * interest / 100; // Fallback to simple interest
      }
      
      return maturity - amount;
    } catch (e) {
      print('Error in calculateReturns: $e');
      return amount * interest / 100; // Fallback to simple interest
    }
  }

  static double calculateReturnsPercentage(double returns, double amount, {bool isRecurring = false, int? durationInMonths}) {
    if (amount == 0) return 0;
    
    // For recurring deposits, calculate percentage based on total deposits
    if (isRecurring && durationInMonths != null) {
      double totalDeposits = amount * durationInMonths;
      if (totalDeposits == 0) return 0;
      return (returns / totalDeposits) * 100;
    }
    
    // For fixed deposits, calculate percentage based on principal
    return (returns / amount) * 100;
  }

  static double calculateCurrentBalance({
    required double amount,
    required double interest,
    DateTime? startDate,
    int? durationInMonths,
    bool isRecurring = false,
    int compoundingPerYear = 4,
  }) {
    // Return principal if essential data is missing
    if (startDate == null || durationInMonths == null || durationInMonths <= 0) {
      return amount;
    }
    
    try {
      final now = DateTime.now();
      final monthsElapsed = now.difference(startDate).inDays / 30;
      final actualMonths = monthsElapsed.floor();
      
      // If investment hasn't started yet, return 0 or principal
      if (actualMonths < 0) {
        return isRecurring ? 0 : amount;
      }
      
      double rate = interest / 100.0;
      double n = compoundingPerYear.toDouble();
      
      if (isRecurring) {
        // Recurring Deposit: include first deposit immediately on start date
        int depositsMade = (actualMonths + 1);
        if (depositsMade > durationInMonths) depositsMade = durationInMonths;
        if (depositsMade <= 0) return 0;
        
        double balance = 0;

        for (int i = 0; i < depositsMade; i++) {
          // Deposit i was made i months ago; interest accrues for (actualMonths - i) months
          int monthsSinceDeposit = actualMonths - i;
          // Cap the accrual period at the deposit's duration
          if (monthsSinceDeposit > durationInMonths - i) {
            monthsSinceDeposit = durationInMonths - i;
          }
          if (monthsSinceDeposit < 0) monthsSinceDeposit = 0;
          
          double yearsSince = monthsSinceDeposit / 12.0;
          double deposit = amount;
          double accrued = deposit * pow(1 + rate / n, n * yearsSince);
          
          // Check for invalid values
          if (accrued.isNaN || accrued.isInfinite) {
            accrued = deposit;
          }
          
          balance += accrued;
        }

        return balance.isNaN || balance.isInfinite ? amount * depositsMade : balance;
      } else {
        // Fixed Deposit: Accrued value up to today, but capped at maturity
        // Don't calculate interest beyond the maturity date
        final effectiveMonths = actualMonths > durationInMonths ? durationInMonths : actualMonths;
        if (effectiveMonths < 0) return amount;
        
        double yearsElapsed = effectiveMonths / 12.0;
        double accrued = amount * pow(1 + rate / n, n * yearsElapsed);
        
        // Check for invalid values
        if (accrued.isNaN || accrued.isInfinite) {
          return amount;
        }
        
        return accrued;
      }
    } catch (e) {
      // If any error occurs, return a safe fallback value
      print('Error in calculateCurrentBalance: $e');
      return amount;
    }
  }

  // XIRR: Improved weighted average (cash flows and dates needed for true XIRR)
  static double calculateXIRR(List<double> amounts, List<double> interests, double totalInvestment) {
    if (totalInvestment == 0) return 0;
    double weightedSum = 0;
    for (int i = 0; i < amounts.length; i++) {
      weightedSum += (amounts[i] * interests[i]);
    }
    return weightedSum / totalInvestment;
  }

  static double calculateAbsoluteReturns(double currentValue, double totalInvestment) {
    if (totalInvestment == 0) return 0;
    return ((currentValue - totalInvestment) / totalInvestment) * 100;
  }
}
