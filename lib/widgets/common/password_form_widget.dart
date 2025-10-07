import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import 'styled_components.dart';

class PasswordFormWidget extends StatefulWidget {
  final TextEditingController? currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool requireCurrentPassword;
  final String newPasswordLabel;
  final String confirmPasswordLabel;
  final String? currentPasswordLabel;

  const PasswordFormWidget({
    super.key,
    this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    this.requireCurrentPassword = false,
    this.newPasswordLabel = 'Password',
    this.confirmPasswordLabel = 'Confirm Password',
    this.currentPasswordLabel = 'Current Password',
  });

  @override
  State<PasswordFormWidget> createState() => _PasswordFormWidgetState();
}

class _PasswordFormWidgetState extends State<PasswordFormWidget> {
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current Password Field (only if required)
        if (widget.requireCurrentPassword && widget.currentPasswordController != null) ...[
          StyledTextField(
            controller: widget.currentPasswordController!,
            labelText: widget.currentPasswordLabel!,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrentPassword 
                    ? Icons.visibility_outlined 
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
            ),
            obscureText: _obscureCurrentPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current password';
              }
              return null;
            },
          ),
          const SizedBox(height: UIConstants.spacing16),
        ],
        
        // New Password Field
        StyledTextField(
          controller: widget.newPasswordController,
          labelText: widget.newPasswordLabel,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword 
                  ? Icons.visibility_outlined 
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              });
            },
          ),
          obscureText: _obscureNewPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            
            // Check for uppercase letter
            if (!RegExp(r'[A-Z]').hasMatch(value)) {
              return 'Password must contain at least one uppercase letter';
            }
            
            // Check for lowercase letter
            if (!RegExp(r'[a-z]').hasMatch(value)) {
              return 'Password must contain at least one lowercase letter';
            }
            
            // Check for number
            if (!RegExp(r'[0-9]').hasMatch(value)) {
              return 'Password must contain at least one number';
            }
            
            // Check for special character
            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
              return 'Password must contain at least one special character';
            }
            
            if (widget.requireCurrentPassword && 
                widget.currentPasswordController != null &&
                value == widget.currentPasswordController!.text) {
              return 'New password must be different from current password';
            }
            return null;
          },
        ),
        const SizedBox(height: UIConstants.spacing16),
        
        // Confirm Password Field
        StyledTextField(
          controller: widget.confirmPasswordController,
          labelText: widget.confirmPasswordLabel,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword 
                  ? Icons.visibility_outlined 
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          obscureText: _obscureConfirmPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != widget.newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}
