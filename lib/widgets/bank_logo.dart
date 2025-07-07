import 'package:flutter/material.dart';
import '../constants/bank_constants.dart';

class BankLogo extends StatelessWidget {
  final String? bank;

  const BankLogo({
    super.key,
    required this.bank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            (bank != null ? BankConstants.bankColors[bank] : Colors.grey[400])
                ?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (bank != null
                  ? BankConstants.bankColors[bank]
                  : Colors.grey[400]) ??
              Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance,
            size: 16,
            color: bank != null
                ? BankConstants.bankColors[bank]
                : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            bank ?? 'Unknown Bank',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: bank != null
                  ? BankConstants.bankColors[bank]
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
