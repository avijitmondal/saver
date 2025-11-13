import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import 'info_section.dart';

class AccountActionsSection extends StatelessWidget {
  final ProfileController controller;

  const AccountActionsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Account Actions',
      children: [
        _buildActionTile(
          context: context,
          icon: Icons.download,
          title: 'Export Data',
          subtitle: 'Download your investment data as JSON',
          onTap: controller.exportData,
        ),
        _buildActionTile(
          context: context,
          icon: Icons.logout,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          onTap: controller.logout,
        ),
        _buildActionTile(
          context: context,
          icon: Icons.delete_forever,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: controller.deleteAccount,
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, size: 16),
      onTap: onTap,
    );
  }
}
