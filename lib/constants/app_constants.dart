class AppConstants {
  // App Information
  static const String appName = 'Save₹';
  static const String appVersion = '0.0.1';

  // API Endpoints (if applicable)
  static const String baseApiUrl = 'http://localhost:8881/api/v1';

  static const String waitlistFormUri = 'https://docs.google.com/forms/d/e/1FAIpQLSfrPUXRYbv6M79sc5Qe2aAYGchzmX8bUSI3gcN5MoIBaT5ZMA/viewform?usp=dialog';

  // Default Values
  static const int defaultAnimationDuration = 300; // milliseconds

  // Feature Flags
  static const bool enableDarkMode = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;

  // Set to true to enable developer mode features
  static const bool enableDeveloperMode = true; 

  // Feature Flags
  // Set this to false to disable sample user and go to welcome screen
  static final Map<String, bool> featureFlags = {
    'enableSampleUser': true,
    // Set this to false to disable sample investment data
    'enableSampleInvestmentData': true,
    // Set this to false to disable fixed deposit investment
    'enableFixedDepositInvestment': true,
    // Set this to false to disable recurring deposit investment
    'enableRecurringDepositInvestment': true,
    // Set this to false to disable public provident fund investment
    'enablePublicProvidentFundInvestment': true,
    // Set this to false to disable employee provident fund investment
    'enableEmployeeProvidentFundInvestment': true,
    // Set this to false to disable mutual fund investment
    'enableMutualFundInvestment': false,
    // Set this to false to disable stock investment
    'enableStockInvestment': false,
    // Set this to false to disable gold investment
    'enableGoldInvestment': false,
    // Set this to false to disable real estate investment
    'enableRealEstateInvestment': false,
    // Set this to false to disable cryptocurrency investment
    'enableCryptocurrencyInvestment': false,
    // Set this to false to disable comming soon screen
    'enableComingSoonScreen': false,
  };
}
