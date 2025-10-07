import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import 'package:provider/provider.dart';
import '../providers/feature_flags_provider.dart';

class InvestmentType {
  final String name;
  final IconData icon;
  final Color color;
  final String? category;

  const InvestmentType({
    required this.name,
    required this.icon,
    required this.color,
    this.category,
  });
}

class InvestmentConstants {
  static const fixedDeposit = InvestmentType(
    name: 'Fixed Deposit',
    icon: Icons.account_balance,
    color: Colors.blue,
    category: 'Deposits',
  );

  static const recurringDeposit = InvestmentType(
    name: 'Recurring Deposit',
    icon: Icons.repeat,
    color: Colors.purple,
    category: 'Deposits',
  );

  static const ppf = InvestmentType(
    name: 'PPF',
    icon: Icons.savings,
    color: Colors.green,
    category: 'Other',
  );

  static const epf = InvestmentType(
    name: 'EPF',
    icon: Icons.account_balance_wallet,
    color: Colors.orange,
    category: 'Other',
  );

  static const List<InvestmentType> allTypes = [
    fixedDeposit,
    recurringDeposit,
    ppf,
    epf,
  ];

  static const List<String> categories = [
    'Deposits',
    'Other',
  ];

  // These methods now require BuildContext to access Provider
  static List<InvestmentType> getTypesByCategory(BuildContext context, String category) {
    final flags = Provider.of<FeatureFlagsProvider>(context, listen: false).flags;
    final showFD = flags['fixedDepositInvestment'] ?? true;
    final showRD = flags['recurringDepositInvestment'] ?? true;
    final showPPF = flags['publicProvidentFundInvestment'] ?? true;
    return allTypes.where((type) {
      if (type.name == fixedDeposit.name && !showFD) return false;
      if (type.name == recurringDeposit.name && !showRD) return false;
      if (type.name == ppf.name && !showPPF) return false;
      return type.category == category;
    }).toList();
  }

  static InvestmentType? getTypeByName(BuildContext context, String name) {
    final flags = Provider.of<FeatureFlagsProvider>(context, listen: false).flags;
    final showFD = flags['fixedDepositInvestment'] ?? true;
    final showRD = flags['recurringDepositInvestment'] ?? true;
    final showPPF = flags['publicProvidentFundInvestment'] ?? true;
    if (name == fixedDeposit.name && !showFD) return null;
    if (name == recurringDeposit.name && !showRD) return null;
    if (name == ppf.name && !showPPF) return null;
    try {
      return allTypes.firstWhere((type) => type.name == name);
    } catch (e) {
      return null;
    }
  }
}
