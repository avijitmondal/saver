import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/investment.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/common/password_form_widget.dart';
import '../constants/ui_constants.dart';
import '../utils/validators.dart';
import '../services/data_import_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;

  int _currentStep = 0;
  bool _isLoading = false;
  List<Investment>? _importedInvestments;

  @override
  void initState() {
    super.initState();
    // Check if we have imported data passed as argument
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final importResult = ModalRoute.of(context)?.settings.arguments as ImportResult?;
      if (importResult != null && importResult.success) {
        _prefillFromImport(importResult);
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _prefillFromImport(ImportResult importResult) {
    if (importResult.user != null) {
      setState(() {
        _firstNameController.text = importResult.user!.firstName;
        _lastNameController.text = importResult.user!.lastName;
        _emailController.text = importResult.user!.email;
        _phoneController.text = importResult.user!.phone;
        _addressController.text = importResult.user!.address;
        _selectedDate = importResult.user!.dateOfBirth;
        _selectedGender = importResult.user!.gender;
      });
    }

    // Store investments temporarily for after registration
    if (importResult.investments != null && importResult.investments!.isNotEmpty) {
      _importedInvestments = importResult.investments!;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data imported successfully! ${importResult.investments!.length} investments will be added after you set your password.',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 1) {
      // Only validate the current form fields based on the step
      bool isValid = true;
      if (_currentStep == 0) {
        isValid = _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            Validators.validateEmail(_emailController.text) == null &&
            _phoneController.text.isNotEmpty &&
            Validators.validateIndianPhone(_phoneController.text) == null &&
            _addressController.text.isNotEmpty &&
            _selectedDate != null &&
            _selectedGender != null &&
            Validators.validateAge(_selectedDate) == null;
      }

      if (isValid) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        String errorMessage = 'Please fill all fields correctly';
        if (_selectedDate != null) {
          final ageError = Validators.validateAge(_selectedDate);
          if (ageError != null) {
            errorMessage = ageError;
          }
        } else if (_selectedDate == null) {
          errorMessage = 'Please select your date of birth';
        } else if (_selectedGender == null) {
          errorMessage = 'Please select your gender';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: UIConstants.errorColor,
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      final ageError = Validators.validateAge(_selectedDate);
      if (ageError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ageError),
            backgroundColor: UIConstants.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Create user data in provider (this will save to storage)
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.createUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          dateOfBirth: _selectedDate!,
          password: _passwordController.text,
          gender: _selectedGender!,
        );

        // Simulate registration delay
        await Future.delayed(const Duration(seconds: 1));

        // Add imported investments if any
        if (_importedInvestments != null && _importedInvestments!.isNotEmpty) {
          final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);
          for (final investment in _importedInvestments!) {
            portfolioProvider.addInvestment(investment);
          }
        }

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: UIConstants.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Max date is 18 years ago
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue:
                  _currentStep == 0 ? _nextStep : _submitRegistration,
              onStepCancel: _currentStep == 0 ? null : _previousStep,
              elevation: 0,
              type: StepperType.horizontal,
              physics: const ClampingScrollPhysics(),
              controlsBuilder: (context, details) {
                return Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _currentStep == 0 ? 'Next' : 'Create Account',
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const Text('Personal Info'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fill in your details to get started',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Please fill in your personal information',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) => Validators.validateRequired(value, 'first name'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) => Validators.validateRequired(value, 'last name'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => Validators.validateEmail(value),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => Validators.validateIndianPhone(value),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        maxLines: 3,
                        validator: (value) => Validators.validateRequired(value, 'address'),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon:
                                const Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(_formatDate(_selectedDate)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        hint: const Text('Select Gender'),
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(value: 'female', child: Text('Female')),
                          DropdownMenuItem(value: 'other', child: Text('Other')),
                          DropdownMenuItem(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('Security'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Set up your password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose a strong password to secure your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PasswordFormWidget(
                        newPasswordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        requireCurrentPassword: false,
                        newPasswordLabel: 'Password',
                        confirmPasswordLabel: 'Confirm Password',
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
