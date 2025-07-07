import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class FeatureFlagsProvider extends ChangeNotifier {
  final Map<String, bool> _flags = Map<String, bool>.from(AppConstants.featureFlags);

  Map<String, bool> get flags => Map.unmodifiable(_flags);

  void setFlag(String key, bool value) {
    _flags[key] = value;
    notifyListeners();
  }
}
