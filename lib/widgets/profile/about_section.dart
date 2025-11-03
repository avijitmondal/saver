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
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Version'),
          subtitle: Text(_version),
        ),
      ],
    );
  }
}

