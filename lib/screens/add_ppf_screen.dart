import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/investment_constants.dart';
import '../models/investment.dart';
import '../providers/portfolio_provider.dart';
import '../utils/date_utils.dart';
import 'package:flutter/services.dart';

class AddPPFScreen extends StatefulWidget {
  const AddPPFScreen({super.key});

  @override
  State<AddPPFScreen> createState() => _AddPPFScreenState();
}

class _AddPPFScreenState extends State<AddPPFScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();
  DateTime? _startDate;
  String? _selectedBank;

  @override
  void dispose() {
    _amountController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select Start Date',
      cancelText: 'CANCEL',
      confirmText: 'OK',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Invalid date',
      fieldLabelText: 'Start Date',
      keyboardType: TextInputType.datetime,
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _startDate != null) {
      final portfolio = context.read<PortfolioProvider>();
      final investment = Investment(
        type: InvestmentConstants.ppf.name,
        amount: double.parse(_amountController.text),
        interest: double.parse(_interestController.text),
        icon: InvestmentConstants.ppf.icon,
        color: InvestmentConstants.ppf.color,
        startDate: _startDate,
        durationInMonths: 180, // 15 years for PPF
        bank: _selectedBank,
      );

      portfolio.addInvestment(investment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add PPF Account'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Initial Amount',
                  prefixText: '₹',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _interestController,
                decoration: const InputDecoration(
                  labelText: 'Interest Rate',
                  hintText: 'e.g., 7.10',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the interest rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid interest rate';
                  }
                  // Ensure the value has at most 2 decimal places
                  if (value.contains('.')) {
                    final parts = value.split('.');
                    if (parts.length > 1 && parts[1].length > 2) {
                      return 'Please enter at most 2 decimal places';
                    }
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _startDate == null
                            ? 'Select Date'
                            : DateFormatter.formatDate(_startDate),
                        style: TextStyle(
                          color: _startDate == null
                              ? Colors.grey[600]
                              : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              if (_startDate == null) ...[
                const SizedBox(height: 8),
                Text(
                  'Please select a start date',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: const InputDecoration(
                  labelText: 'Bank',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'SBI',
                  'HDFC',
                  'ICICI',
                  'Post Office',
                ].map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBank = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a bank';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add PPF Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
