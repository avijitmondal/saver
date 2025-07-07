import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../../utils/theme_helper.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final double avatarRadius;
  final double iconSize;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.email,
    this.avatarRadius = 50,
    this.iconSize = 50,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacing16),
      decoration: ThemeHelper.getCardDecoration(
        context,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: iconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: UIConstants.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onEditPressed != null) ...[
                const SizedBox(width: UIConstants.spacing8),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: onEditPressed,
                ),
              ],
            ],
          ),
          Text(
            email.trim(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: UIConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
