import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../../utils/validators.dart';
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
            validator: (value) => Validators.validateRequired(value, 'current password'),
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
            final passwordError = Validators.validatePassword(value);
            if (passwordError != null) return passwordError;
            
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
          validator: (value) => Validators.validateConfirmPassword(
            value, 
            widget.newPasswordController.text,
          ),
        ),
      ],
    );
  }
}
