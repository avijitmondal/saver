class AppConstants {
  // App Information
  static const String appName = 'Saver';
  static const String appVersion = '1.0.0';

  // API Endpoints (if applicable)
  static const String baseApiUrl = 'http://localhost:8881/api/v1';

  static const String waitlistFormUri = 'https://docs.google.com/forms/d/e/1FAIpQLSfrPUXRYbv6M79sc5Qe2aAYGchzmX8bUSI3gcN5MoIBaT5ZMA/viewform?usp=dialog';

  // Default Values
  static const int defaultAnimationDuration = 300; // milliseconds

  // Password validation constants
  static const int minPasswordLength = 8;
  static const String passwordUppercasePattern = r'[A-Z]';
  static const String passwordLowercasePattern = r'[a-z]';
  static const String passwordNumberPattern = r'[0-9]';
  static const String passwordSpecialCharPattern = r'[!@#$%^&*(),.?":{}|<>]';

  // Feature Flags
  static const bool enableDarkMode = false;
  static const bool enableNotifications = false; // temporarily disabled
  static const bool enableAnalytics = true;

  // Set to true to enable developer mode features
  static const bool enableDeveloperMode = false; 

  // Feature Flags
  // Set this to false to disable sample user and go to welcome screen
  static final Map<String, bool> featureFlags = {
    // Keys renamed (removed 'enable' prefix)
    'sampleUser': false,
    // Set this to false to disable sample investment data
    'sampleInvestmentData': false,
    // Set this to false to disable coming soon screen
    'comingSoonScreen': true,
    // Set this to false to disable fixed deposit investment
    'fixedDepositInvestment': true,
    // Set this to false to disable recurring deposit investment
    'recurringDepositInvestment': true,
    // Set this to false to disable public provident fund investment
    'publicProvidentFundInvestment': false,
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
