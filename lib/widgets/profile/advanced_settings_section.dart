import 'package:flutter/material.dart';
import 'package:saver/widgets/profile/info_section.dart';
import '../../../screens/developer_mode_screen.dart';

class AdvancedSettingsSection extends StatelessWidget {
  const AdvancedSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Advanced Actions',
      children: [
        ListTile(
            leading: const Icon(Icons.developer_mode),
            title: const Text('Developer Mode'),
            trailing: const Icon(Icons.chevron_right),
            subtitle: const Text('View and toggle developer flags'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DeveloperModeScreen(),
                ),
              );
            },
          ),
      ],
    );
  }
}
