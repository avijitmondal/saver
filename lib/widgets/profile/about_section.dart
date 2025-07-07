import 'package:flutter/material.dart';
import 'package:saver/widgets/profile/info_section.dart';
import '../../constants/app_constants.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'About',
      children: [
        Text(
            'developed by',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'MatkaDada',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'App Version: ${AppConstants.appVersion}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}
