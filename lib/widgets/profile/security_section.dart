import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import 'info_list_tile.dart';
import 'info_section.dart';

class SecuritySection extends StatelessWidget {
  final ProfileController controller;

  const SecuritySection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Security',
      children: [
        InfoListTile(
          icon: Icons.lock,
          title: 'Change Password',
          subtitle: 'Update your password',
          trailing: const Icon(Icons.chevron_right),
          onTap: controller.changePassword,
        ),
        /*ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Two-Factor Authentication'),
          subtitle: const Text('Enable additional security'),
          trailing: Switch(
            value: controller.isTwoFactorEnabled,
            onChanged: controller.updateTwoFactorAuth,
          ),
        ),*/
        const Divider(height: 1),
      ],
    );
  }
}
