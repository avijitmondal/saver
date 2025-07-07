import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../common/styled_components.dart';

class InfoListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const InfoListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.iconColor,
    this.titleColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: iconColor ?? Theme.of(context).colorScheme.primary,
            size: UIConstants.standardIconSize,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: UIConstants.textSecondaryColor,
                ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
        const StyledDivider(),
      ],
    );
  }
}
