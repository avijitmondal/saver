import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../../utils/theme_helper.dart';

/// A styled primary button with consistent appearance
class StyledPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;

  const StyledPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ThemeHelper.getPrimaryButtonStyle(context),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}

/// A styled secondary button with consistent appearance
class StyledSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;

  const StyledSecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: ThemeHelper.getSecondaryButtonStyle(context),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Text(text),
      ),
    );
  }
}

/// A styled text button with consistent appearance
class StyledTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const StyledTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ThemeHelper.getTextButtonStyle(context),
      child: Text(text),
    );
  }
}

/// A styled text field with consistent appearance
class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const StyledTextField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: ThemeHelper.getInputDecoration(
        context,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}

/// A styled card with consistent appearance
class StyledCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  const StyledCard({
    Key? key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? ThemeHelper.getCardPadding(),
        decoration: ThemeHelper.getCardDecoration(context, color: color),
        child: child,
      ),
    );
  }
}

/// A styled section header with consistent appearance
class StyledSectionHeader extends StatelessWidget {
  final String title;

  const StyledSectionHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeHelper.getSectionHeader(context, title);
  }
}

/// A styled icon with background
class StyledIconWithBackground extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const StyledIconWithBackground({
    Key? key,
    required this.icon,
    this.size = UIConstants.standardIconSize,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeHelper.getIconWithBackground(
      context,
      icon,
      size: size,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }
}

/// A styled divider with consistent appearance
class StyledDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  const StyledDivider({
    Key? key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: UIConstants.dividerColor,
    );
  }
}

/// A styled app logo with consistent appearance
class StyledAppLogo extends StatelessWidget {
  final double size;

  const StyledAppLogo({
    Key? key,
    this.size = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.account_balance_wallet_outlined,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
} 