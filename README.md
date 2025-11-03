# Saver

A modern, cross-platform personal finance and investment tracking app built with Flutter. Saver helps you manage, monitor, and grow your wealth by tracking investments, analyzing returns, and visualizing your financial portfolio—all in one place.

![Version](https://img.shields.io/badge/version-1.0.3-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0.0-0175C2?logo=dart)

---

## Features

### Investment Management
- **Multiple Investment Types**: 
  - ✅ **Fixed Deposits (FD)**: Fully supported with maturity calculations
  - ✅ **Recurring Deposits (RD)**: Track monthly contributions and returns
  - 🚧 *Coming Soon*: PPF, EPF, Mutual Funds, Stocks, Gold, Real Estate, and Cryptocurrency
- **Comprehensive Details**: Record principal, interest rates, tenure, compounding frequency, and maturity dates
- **Real-Time Calculations**: Automatic computation of returns, current balance, and maturity amounts
- **Payment History**: Track contributions and payments over time for recurring investments
- **Swipe to Delete**: Quick removal of investments from the list with a left swipe gesture

### Analytics & Insights
- **Portfolio Distribution**: Visual breakdown of investments by type with interactive pie charts
- **Return Analysis**: Monitor gains/losses across all investments
- **Bank-Wise Tracking**: View investments grouped by financial institution
- **Maturity Timeline**: See upcoming maturities and plan accordingly

### User Experience
- **Dark Mode**: System-aware theme switching with persistent user preference
- **Profile Management**: Secure password-protected profiles with customizable settings
- **Responsive Design**: Optimized for mobile, tablet, and desktop
- **Sample Data**: Built-in demo mode for exploring features (can be disabled for production)

### Developer Features
- **Feature Flags**: Toggle experimental features via compile-time flags
- **Advanced Settings**: Developer mode with debugging tools and configuration options
- **Test Coverage**: Comprehensive unit tests with ~90% coverage on core models

---

## Screenshots

_Coming soon_

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.10.0`
- Dart SDK `>=3.0.0`
- iOS, Android, Web, or Desktop development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/avijitmondal/saver.git
   cd saver
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # With sample data (default for development)
   flutter run
   
   # Without sample data (production mode)
   flutter run --dart-define=SAMPLE_DATA=false
   
   # With developer tools enabled
   flutter run --dart-define=DEVELOPER_MODE=true
   ```

---

## Building for Production

Saver includes a unified build script that handles all platforms and automatically disables sample data and developer mode for release builds.

### Android (AAB)
```bash
./build.sh android
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (App Store/TestFlight)
```bash
./build.sh ios
```
Output: `build/ios/ipa/`

### Web
```bash
./build.sh web
```
Output: `build/web/`

The build script automatically applies these flags:
- `--dart-define=SAMPLE_DATA=false`
- `--dart-define=DEVELOPER_MODE=false`

---

## Configuration

### Environment Flags

Saver uses compile-time environment flags to prevent accidental shipping of demo data or debug features.

| Flag | Default | Description |
|------|---------|-------------|
| `SAMPLE_DATA` | `true` | Loads sample user profile and investments for testing UI |
| `DEVELOPER_MODE` | `false` | Shows advanced settings and developer tools in profile |

**Example: Production-like local run**
```bash
flutter run \
  --dart-define=SAMPLE_DATA=false \
  --dart-define=DEVELOPER_MODE=false
```

**Example: Full development mode**
```bash
flutter run \
  --dart-define=SAMPLE_DATA=true \
  --dart-define=DEVELOPER_MODE=true
```

### Feature Flags

Runtime feature toggles are defined in `lib/constants/app_constants.dart`:
```dart
static final Map<String, bool> featureFlags = {
  'notifications': false,
  'comingSoonScreen': false,
  'fixedDepositInvestment': true,
  'recurringDepositInvestment': true,
  'publicProvidentFundInvestment': false,
  // ... more flags
};
```

Toggle these to enable/disable specific investment types or experimental features.

### Supported Banks

The app includes pre-configured colors and branding for major Indian banks:
- State Bank of India (SBI)
- HDFC Bank
- ICICI Bank
- Axis Bank
- Kotak Mahindra Bank
- Punjab National Bank
- Bank of Baroda
- Canara Bank
- IDFC First Bank
- IndusInd Bank
- Yes Bank

Add custom banks via `lib/constants/bank_constants.dart`.

---

## Project Structure

```
lib/
├── constants/        # App-wide constants and configuration
├── controllers/      # Business logic controllers
├── data/            # Sample data and fixtures
├── models/          # Data models (Investment, User, etc.)
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens
├── services/        # Storage, calculations, and utilities
├── utils/           # Helper functions
└── widgets/         # Reusable UI components

test/                # Unit and widget tests
```

---

## Testing

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### View coverage report
```bash
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser (macOS)
open coverage/html/index.html
```

Current coverage: **~90%** on core investment models.

---

## Architecture

- **State Management**: Provider pattern for reactive UI updates
- **Storage**: SharedPreferences for local persistence
- **Calculations**: Compound interest engine with support for multiple compounding frequencies
- **Routing**: Named routes with custom route configuration
- **Theming**: Material Design 3 with dynamic light/dark mode

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `shared_preferences` | Local data persistence |
| `fl_chart` | Portfolio visualization charts |
| `intl` | Number and date formatting |
| `crypto` | Secure password hashing |
| `package_info_plus` | App version information |
| `get_it` | Service locator / dependency injection |

See [`pubspec.yaml`](pubspec.yaml) for full dependency list.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes with tests
4. Ensure tests pass (`flutter test`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Guidelines
- Follow the existing code style (enforced by `flutter_lints`)
- Write unit tests for new features
- Update documentation for API changes
- Keep commits atomic and well-described

---

## Roadmap

- [ ] Cloud sync and backup
- [ ] Multi-currency support
- [ ] Export to CSV/PDF
- [ ] Investment goal tracking
- [ ] Budget management
- [ ] Expense tracking integration
- [ ] Notifications for maturity dates
- [ ] Tax calculation helpers

---

## License

This project is private and not currently licensed for public use. For collaboration inquiries, please contact the repository owner.

---

## Acknowledgments

Built with ❤️ using [Flutter](https://flutter.dev/)

Special thanks to:
- [fl_chart](https://github.com/imaNNeo/fl_chart) for beautiful charts
- The Flutter community for excellent packages and support

---

## Contact

**Project Maintainer**: [Avijit](https://github.com/avijitmondal)

For bug reports and feature requests, please [open an issue](https://github.com/avijitmondal/saver/issues).

