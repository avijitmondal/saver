import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saver/widgets/profile/info_section.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  String _version = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'About',
      children: [
        Text(
          'Version: $_version',
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

