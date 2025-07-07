import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/investment.dart';
import '../utils/date_utils.dart';
import '../utils/number_formatter.dart';
import '../constants/investment_constants.dart';
import 'package:flutter/services.dart';

class AddEPFScreen extends StatefulWidget {
  const AddEPFScreen({super.key});

  @override
  State<AddEPFScreen> createState() => _AddEPFScreenState();
}

class _AddEPFScreenState extends State<AddEPFScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();
  DateTime? _startDate;
  DateTime? _maturityDate;
  int _durationInMonths = 60; // Default 5 years

  @override
  void dispose() {
    _amountController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? DateTime.now()
          : DateTime.now().add(const Duration(days: 365 * 5)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _calculateMaturityDate();
        } else {
          _maturityDate = picked;
          _calculateDuration();
        }
      });
    }
  }

  void _calculateMaturityDate() {
    if (_startDate != null) {
      setState(() {
        _maturityDate = DateTime(
          _startDate!.year + (_durationInMonths ~/ 12),
          _startDate!.month + (_durationInMonths % 12),
          _startDate!.day,
        );
      });
    }
  }

  void _calculateDuration() {
    if (_startDate != null && _maturityDate != null) {
      setState(() {
        _durationInMonths = ((_maturityDate!.year - _startDate!.year) * 12) +
            (_maturityDate!.month - _startDate!.month);
      });
    }
  }

  void _saveInvestment() {
    if (_formKey.currentState!.validate()) {
      final investment = Investment(
        type: InvestmentConstants.epf.name,
        amount: double.parse(_amountController.text),
        interest: double.parse(_interestController.text),
        startDate: _startDate,
        durationInMonths: _durationInMonths,
        isRecurring: false,
        color: InvestmentConstants.epf.color,
        icon: InvestmentConstants.epf.icon,
      );

      context.read<PortfolioProvider>().addInvestment(investment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add EPF Account'),
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
                    return 'Please enter an amount';
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
                  labelText: 'Interest Rate (%)',
                  hintText: 'e.g., 8.15',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an interest rate';
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
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _startDate != null
                            ? DateFormatter.formatDate(_startDate!)
                            : 'Select Date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Maturity Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _maturityDate != null
                            ? DateFormatter.formatDate(_maturityDate!)
                            : 'Select Date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveInvestment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add EPF Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
