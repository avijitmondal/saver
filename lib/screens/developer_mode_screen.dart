import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feature_flags_provider.dart';

class DeveloperModeScreen extends StatefulWidget {
  const DeveloperModeScreen({super.key});

  @override
  State<DeveloperModeScreen> createState() => _DeveloperModeScreenState();
}

class _DeveloperModeScreenState extends State<DeveloperModeScreen> {

  @override
  void initState() {
    super.initState();
    // Will be initialized in build from provider
  }

  void _updateFlag(BuildContext context, String key, bool value) {
    final featureFlagsProvider = Provider.of<FeatureFlagsProvider>(context, listen: false);
    featureFlagsProvider.setFlag(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeatureFlagsProvider>(
      builder: (context, featureFlagsProvider, _) {
        final flags = featureFlagsProvider.flags;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Developer Mode'),
          ),
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Developer Flags',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ...flags.entries.map((entry) {
                return SwitchListTile(
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (val) {
                    _updateFlag(context, entry.key, val);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
