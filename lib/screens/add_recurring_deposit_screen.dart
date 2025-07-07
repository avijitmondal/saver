import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/investment.dart';
import '../utils/date_utils.dart';
import '../constants/bank_constants.dart';
import 'package:flutter/services.dart';

class AddRecurringDepositScreen extends StatefulWidget {
  const AddRecurringDepositScreen({super.key});

  @override
  State<AddRecurringDepositScreen> createState() =>
      _AddRecurringDepositScreenState();
}

class _AddRecurringDepositScreenState extends State<AddRecurringDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyAmountController = TextEditingController();
  final _interestController = TextEditingController();
  String? _selectedBank;
  DateTime? _startDate;
  int? _durationInMonths;

  @override
  void dispose() {
    _monthlyAmountController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Select Start Date',
      cancelText: 'Cancel',
      confirmText: 'Set',
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
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _durationInMonths != null &&
        _selectedBank != null) {
      final portfolio = context.read<PortfolioProvider>();

      final newDeposit = Investment(
        type: 'Recurring Deposit',
        amount: double.parse(_monthlyAmountController.text),
        interest: double.parse(_interestController.text),
        icon: Icons.account_balance,
        color: Colors.purple,
        startDate: _startDate,
        durationInMonths: _durationInMonths,
        bank: _selectedBank,
        isRecurring: true,
      );

      portfolio.addInvestment(newDeposit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recurring Deposit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: const InputDecoration(
                  labelText: 'Bank',
                  border: OutlineInputBorder(),
                ),
                items: BankConstants.banks.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a bank';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthlyAmountController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Deposit Amount',
                  border: OutlineInputBorder(),
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the monthly amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _interestController,
                decoration: const InputDecoration(
                  labelText: 'Interest Rate',
                  hintText: 'e.g., 6.80',
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
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _durationInMonths,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                ),
                items: BankConstants.fdDurations.map((months) {
                  return DropdownMenuItem(
                    value: months,
                    child: Text(DateFormatter.formatDuration(months)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _durationInMonths = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add Recurring Deposit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
