import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../constants/ui_constants.dart';
import '../widgets/common/styled_components.dart';
import '../widgets/common/app_scaffold.dart';
import '../widgets/common/password_form_widget.dart';
import '../config/route_config.dart';
import '../utils/validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isForgotPassword;
  
  const ChangePasswordScreen({
    super.key,
    this.isForgotPassword = false,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (date == null) return 'Select Date of Birth';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      if (widget.isForgotPassword) {
        // Validate date of birth
        if (_selectedDate == null) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select your date of birth'),
              backgroundColor: UIConstants.errorColor,
            ),
          );
          return;
        }

        // Forgot password flow - validate email, phone, and date of birth
        bool isValidUser = userProvider.email == _emailController.text && 
                          userProvider.phone == _phoneController.text &&
                          userProvider.dateOfBirth.day == _selectedDate!.day &&
                          userProvider.dateOfBirth.month == _selectedDate!.month &&
                          userProvider.dateOfBirth.year == _selectedDate!.year;
        
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (!isValidUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('The provided information does not match our records'),
              backgroundColor: UIConstants.errorColor,
            ),
          );
          return;
        }

        // Update password
        userProvider.setPassword(_newPasswordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password reset successful! Please login with your new password.'),
            backgroundColor: UIConstants.successColor,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        
        if (!mounted) return;
        
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteConfig.login,
          (route) => false,
        );
      } else {
        // Change password flow
        final bool isCurrentPasswordValid = userProvider.validatePassword(_currentPasswordController.text);

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (!isCurrentPasswordValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Current password is incorrect'),
              backgroundColor: UIConstants.errorColor,
            ),
          );
          return;
        }

        userProvider.setPassword(_newPasswordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password changed successfully! Please login again.'),
            backgroundColor: UIConstants.successColor,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        
        if (!mounted) return;
        
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteConfig.login,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChangePassword = !widget.isForgotPassword;
    
    return AppScaffold(
      showAppBar: true,
      useGradientBackground: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: UIConstants.spacing24),
            
            Text(
              widget.isForgotPassword ? 'Reset your password' : 'Update your password',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UIConstants.spacing8),
            
            Text(
              widget.isForgotPassword 
                  ? 'Enter your email and phone number to verify your identity'
                  : 'Enter your current password and choose a new one',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: UIConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UIConstants.spacing32),
            
            // Forgot Password Fields
            if (widget.isForgotPassword) ...[
              StyledTextField(
                controller: _emailController,
                labelText: 'Email Address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.validateEmail(value),
              ),
              const SizedBox(height: UIConstants.spacing16),
              
              StyledTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => Validators.validateIndianPhone(value),
              ),
              const SizedBox(height: UIConstants.spacing16),
              
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _formatDate(_selectedDate),
                    style: TextStyle(
                      color: _selectedDate == null ? Colors.grey : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: UIConstants.spacing24),
            ],
            
            // Password Form Widget
            PasswordFormWidget(
              currentPasswordController: isChangePassword ? _currentPasswordController : null,
              newPasswordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
              requireCurrentPassword: isChangePassword,
              newPasswordLabel: widget.isForgotPassword ? 'New Password' : 'New Password',
              confirmPasswordLabel: widget.isForgotPassword ? 'Confirm New Password' : 'Confirm New Password',
              currentPasswordLabel: 'Current Password',
            ),
            const SizedBox(height: UIConstants.spacing32),
            
            // Submit Button
            StyledPrimaryButton(
              text: widget.isForgotPassword ? 'Reset Password' : 'Change Password',
              onPressed: _handleSubmit,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
