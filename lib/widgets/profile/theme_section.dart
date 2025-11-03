import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'info_section.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final currentTheme = userProvider.themeMode;
        
        return InfoSection(
          title: 'Appearance',
          children: [
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Theme'),
              subtitle: Text(_getThemeDisplayName(currentTheme)),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _showThemeDialog(context, userProvider),
            ),
          ],
        );
      },
    );
  }

  String _getThemeDisplayName(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System Default';
    }
  }

  void _showThemeDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('System Default'),
              subtitle: Text('Follow device settings'),
              value: 'system',
              groupValue: userProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  userProvider.updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text('Light'),
              subtitle: Text('Always use light theme'),
              value: 'light',
              groupValue: userProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  userProvider.updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text('Dark'),
              subtitle: Text('Always use dark theme'),
              value: 'dark',
              groupValue: userProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  userProvider.updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
