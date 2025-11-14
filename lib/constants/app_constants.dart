class AppConstants {
  // App Information
  static const String appName = 'Saver';

  // Default Values
  static const int defaultAnimationDuration = 300; // milliseconds

  // Payment History Display Limits
  static const int maxCompletedPaymentsToShow = 12;
  static const int maxUpcomingPaymentsToShow = 3;

  // Password validation constants
  static const int minPasswordLength = 8;
  static const String passwordUppercasePattern = r'[A-Z]';
  static const String passwordLowercasePattern = r'[a-z]';
  static const String passwordNumberPattern = r'[0-9]';
  static const String passwordSpecialCharPattern = r'[!@#$%^&*(),.?":{}|<>]';

  // Environment-configurable switches (use --dart-define on build/run)
  // Examples:
  //   flutter run --dart-define=SAMPLE_DATA=true --dart-define=DEVELOPER_MODE=true
  //   flutter build appbundle --release --dart-define=SAMPLE_DATA=false --dart-define=DEVELOPER_MODE=false
  // Defaults: SAMPLE_DATA=true (for local convenience), DEVELOPER_MODE=false (hidden advanced UI)
  static const bool developerMode = bool.fromEnvironment('DEVELOPER_MODE', defaultValue: false);
  static const bool sampleData = bool.fromEnvironment('SAMPLE_DATA', defaultValue: true);

  // Feature Flags
  // Set this to false to disable sample user and go to welcome screen
  static final Map<String, bool> featureFlags = {
    // Toggle in-app notifications
    'notifications': false,
    // Set this to false to disable coming soon screen
    'comingSoonScreen': false,
    // Set this to false to disable fixed deposit investment
    'fixedDepositInvestment': true,
    // Set this to false to disable recurring deposit investment
    'recurringDepositInvestment': true,
    // Set this to false to disable public provident fund investment
    'publicProvidentFundInvestment': true,
    // Set this to false to disable employee provident fund investment
    'employeeProvidentFundInvestment': false,
    // Set this to false to disable mutual fund investment
    'mutualFundInvestment': false,
    // Set this to false to disable stock investment
    'stockInvestment': false,
    // Set this to false to disable gold investment
    'goldInvestment': false,
    // Set this to false to disable real estate investment
    'realEstateInvestment': false,
    // Set this to false to disable cryptocurrency investment
    'cryptocurrencyInvestment': false,
  };
}
