import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import 'info_list_tile.dart';
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
        InfoListTile(
          icon: Icons.backup,
          title: 'Export Data',
          subtitle: 'Download your account data',
          trailing: const Icon(Icons.chevron_right),
          onTap: controller.exportData,
        ),
        InfoListTile(
          icon: Icons.logout,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          trailing: const Icon(Icons.chevron_right),
          onTap: controller.logout,
        ),
        InfoListTile(
          icon: Icons.delete_forever,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          iconColor: Colors.red,
          titleColor: Colors.red,
          trailing: const Icon(Icons.chevron_right, color: Colors.red),
          onTap: controller.deleteAccount,
        ),
      ],
    );
  }
}
