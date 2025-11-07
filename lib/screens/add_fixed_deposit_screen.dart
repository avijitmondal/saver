import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/investment.dart';
import '../utils/date_utils.dart';
import '../constants/bank_constants.dart';
import '../constants/ui_constants.dart';
import '../utils/validators.dart';
import 'package:flutter/services.dart';

class AddFixedDepositScreen extends StatefulWidget {
  const AddFixedDepositScreen({super.key});

  @override
  State<AddFixedDepositScreen> createState() => _AddFixedDepositScreenState();
}

class _AddFixedDepositScreenState extends State<AddFixedDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();
  String? _selectedBank;
  DateTime? _startDate;
  int? _durationInMonths;
  String _compoundingFrequency = 'quarterly';

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
      lastDate: DateTime.now(), // Prevent selecting future dates
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
      
      // Additional validation for start date
      if (_startDate!.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Start date cannot be in the future'),
            backgroundColor: UIConstants.errorColor,
          ),
        );
        return;
      }

      final portfolio = context.read<PortfolioProvider>();

      final newDeposit = Investment.create(
        type: 'Fixed Deposit',
        amount: double.parse(_amountController.text),
        interest: double.parse(_interestController.text),
        icon: Icons.account_balance,
        color: Colors.blue,
        startDate: _startDate,
        durationInMonths: _durationInMonths,
        bank: _selectedBank,
        compoundingFrequency: _compoundingFrequency,
      );

      portfolio.addInvestment(newDeposit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fixed Deposit'),
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
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Principal Amount',
                  border: OutlineInputBorder(),
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) => Validators.validateAmount(value, minAmount: 100),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _interestController,
                decoration: const InputDecoration(
                  labelText: 'Interest Rate',
                  hintText: 'e.g., 7.50',
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
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: const OutlineInputBorder(),
                    errorText: _startDate != null && _startDate!.isAfter(DateTime.now())
                        ? 'Start date cannot be in the future'
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _startDate == null
                            ? 'Select Date'
                            : DateFormatter.formatDate(_startDate),
                        style: TextStyle(
                          color: _startDate != null && _startDate!.isAfter(DateTime.now())
                              ? UIConstants.errorColor
                              : null,
                        ),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _compoundingFrequency,
                decoration: const InputDecoration(
                  labelText: 'Compounding Frequency',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'quarterly',
                    child: Text('Quarterly'),
                  ),
                  DropdownMenuItem(
                    value: 'half-yearly',
                    child: Text('Half-Yearly'),
                  ),
                  DropdownMenuItem(
                    value: 'yearly',
                    child: Text('Yearly'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _compoundingFrequency = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: UIConstants.successColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: UIConstants.spacing16),
                ),
                child: const Text(
                  'Add Fixed Deposit',
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
