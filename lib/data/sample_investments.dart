import '../models/investment.dart';
import '../constants/investment_constants.dart';
import '../constants/app_constants.dart';

class SampleInvestments {
  static List<Investment> getInitialInvestments() {
    // Return empty list if sample data is disabled
  if (!AppConstants.sampleData) {
      return [];
    }

    return [
      // Fixed Deposits - Long Term (3+ years)
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 100000.0,
        interest: 8.00,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 1, 1),
        durationInMonths: 36,
        bank: 'HDFC',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 200000.0,
        interest: 7.80,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 1, 15),
        durationInMonths: 48,
        bank: 'ICICI',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 300000.0,
        interest: 7.50,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 2, 1),
        durationInMonths: 60,
        bank: 'SBI',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 150000.0,
        interest: 7.00,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 3, 15),
        durationInMonths: 60, // 5 years for tax-saving FD
        bank: 'Axis',
        notes: 'Tax-saving FD under Section 80C',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 50000.0,
        interest: 7.40,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 1, 1),
        durationInMonths: 18,
        bank: 'HDFC',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 75000.0,
        interest: 7.20,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 1, 15),
        durationInMonths: 15,
        bank: 'ICICI',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 150000.0,
        interest: 7.60,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 2, 1),
        durationInMonths: 15,
        bank: 'SBI',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 100000.0,
        interest: 8.50,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 2, 20),
        durationInMonths: 24,
        bank: 'Bajaj Finance',
        notes: 'Corporate FD with higher interest rate',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 25000.0,
        interest: 7.20,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2023, 9, 1),
        durationInMonths: 12,
        bank: 'SBI',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 30000.0,
        interest: 7.00,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 2, 15),
        durationInMonths: 6,
        bank: 'ICICI',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 40000.0,
        interest: 6.80,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 3, 10),
        durationInMonths: 3,
        bank: 'HDFC',
      ),
      Investment.create(
        type: InvestmentConstants.fixedDeposit.name,
        amount: 50000.0,
        interest: 6.50,
        icon: InvestmentConstants.fixedDeposit.icon,
        color: InvestmentConstants.fixedDeposit.color,
        startDate: DateTime(2024, 3, 25),
        durationInMonths: 9,
        bank: 'Kotak Mahindra',
        notes: 'Flexible FD with partial withdrawal option',
      ),
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 5000.0,
        interest: 7.00,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 1, 1),
        durationInMonths: 24,
        bank: 'SBI',
        isRecurring: true,
      ),
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 10000.0,
        interest: 7.20,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 2, 1),
        durationInMonths: 36,
        bank: 'HDFC',
        isRecurring: true,
      ),
      // New Senior Citizen RD
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 15000.0,
        interest: 7.75,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 3, 10),
        durationInMonths: 60, // 5 years
        bank: 'PNB',
        isRecurring: true,
        notes: 'Senior Citizen Special RD with higher interest',
      ),

      // Recurring Deposits - Medium Term (1-2 years)
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 3000.0,
        interest: 6.80,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2023, 12, 1),
        durationInMonths: 18,
        bank: 'ICICI',
        isRecurring: true,
      ),
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 2000.0,
        interest: 6.50,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 3, 1),
        durationInMonths: 12,
        bank: 'SBI',
        isRecurring: true,
      ),
      // New Education RD
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 5000.0,
        interest: 7.10,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 2, 15),
        durationInMonths: 24,
        bank: 'Bank of Baroda',
        isRecurring: true,
        notes: 'Education RD for child\'s future',
      ),

      // Recurring Deposits - Short Term (< 1 year)
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 1000.0,
        interest: 6.20,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 2, 15),
        durationInMonths: 6,
        bank: 'HDFC',
        isRecurring: true,
      ),
      // New Flexible RD
      Investment.create(
        type: InvestmentConstants.recurringDeposit.name,
        amount: 2500.0,
        interest: 6.00,
        icon: InvestmentConstants.recurringDeposit.icon,
        color: InvestmentConstants.recurringDeposit.color,
        startDate: DateTime(2024, 3, 5),
        durationInMonths: 9,
        bank: 'Yes Bank',
        isRecurring: true,
        notes: 'Flexible RD with variable monthly deposits',
      ),
      // PPF Account
      Investment.create(
        type: InvestmentConstants.ppf.name,
        amount: 150000.0,
        interest: 7.10,
        icon: InvestmentConstants.ppf.icon,
        color: InvestmentConstants.ppf.color,
        startDate: DateTime(2023, 4, 1),
        durationInMonths: 180, // 15 years
        bank: 'SBI',
      ),
      // New PPF Account
      Investment.create(
        type: InvestmentConstants.ppf.name,
        amount: 100000.0,
        interest: 7.10,
        icon: InvestmentConstants.ppf.icon,
        color: InvestmentConstants.ppf.color,
        startDate: DateTime(2022, 4, 1),
        durationInMonths: 180, // 15 years
        bank: 'Indian Bank',
        notes: 'PPF account for tax benefits',
      ),
      // EPF Contributions
      Investment.create(
        type: InvestmentConstants.epf.name,
        amount: 3500.0, // Monthly contribution amount
        interest: 8.15, // Current EPF interest rate for 2023-24
        icon: InvestmentConstants.epf.icon,
        color: InvestmentConstants.epf.color,
        startDate: DateTime(2020, 4, 1), // Starting from FY 2020-21
        durationInMonths: 480, // 40 years until retirement
        bank: 'EPFO', // Employee Provident Fund Organisation
        isRecurring: true, // Monthly contributions
      ),
      Investment.create(
        type: InvestmentConstants.epf.name,
        amount: 7000.0, // Monthly contribution amount (including VPF)
        interest: 8.15, // Current EPF interest rate for 2023-24
        icon: InvestmentConstants.epf.icon,
        color: InvestmentConstants.epf.color,
        startDate: DateTime(2021, 4, 1), // Starting from FY 2021-22
        durationInMonths: 420, // 35 years until retirement
        bank: 'EPFO', // Employee Provident Fund Organisation
        isRecurring: true, // Monthly contributions
        notes: 'Includes Voluntary Provident Fund (VPF) contribution',
      ),
    ];
  }
}
