# Saver - Personal Investment Tracker 💰

A modern, intuitive investment tracking app that helps you monitor and grow your wealth. Built with Flutter for a seamless cross-platform experience.

[![Get it on Google Play](https://img.shields.io/badge/Google_Play-Download-414141?logo=google-play)](https://play.google.com/store/apps/details?id=com.avijitmondal.saver)
![Version](https://img.shields.io/badge/version-1.0.6-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

---

## ✨ Features

### 📊 Investment Management
Track multiple types of investments in one place:

**Currently Supported:**
- ✅ **Fixed Deposits (FD)** - Track term deposits with automatic maturity calculations
- ✅ **Recurring Deposits (RD)** - Monitor monthly contributions and accrued interest
- ✅ **Public Provident Fund (PPF)** - Long-term savings with tax benefits
- ✅ **Employee Provident Fund (EPF)** - Track employer and employee contributions

**Each investment includes:**
- Principal amount and interest rates
- Maturity dates and automatic return calculations
- Payment history for recurring investments
- Bank/institution details with custom branding
- Notes and tags for better organization

### 📈 Portfolio Analytics
Get insights into your wealth:

- **Portfolio Overview** - See total value at a glance
- **XIRR Calculations** - Accurate annualized returns for recurring investments
- **Absolute Returns** - Track total gains/losses
- **Distribution Charts** - Visual breakdown by investment type
- **Bank-wise Summary** - Investments grouped by institution
- **Maturity Timeline** - Upcoming maturities and renewals

### 👤 Profile & Settings

- **Secure Access** - Password-protected user profiles
- **Data Export** - Download your investment data as JSON
- **Account Management** - Easy logout and account deletion
- **Dark Mode** - Automatic theme based on system preference
- **Personal Information** - Store name, email, phone, and address

### 💾 Data Management

- **Local Storage** - All data stored securely on your device
- **No Cloud Required** - Complete privacy, no external servers
- **Export Capability** - Backup your data anytime
- **Sample Data Mode** - Try the app with demo investments

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.10.0 or higher)
- Android Studio / Xcode / VS Code
- A device or emulator to run the app

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
   flutter run
   ```

That's it! The app will launch with sample data so you can explore features immediately.

> **Note:** For production builds, see [ENGINEERING.md](docs/ENGINEERING.md#-build--deployment).

---

## 📱 How to Use

### Adding Your First Investment

1. **Create Your Profile**
   - Open the app and navigate to Profile
   - Enter your personal information
   - Set a secure password

2. **Add an Investment**
   - Go to the Investments tab
   - Tap the "+" button
   - Choose investment type (FD/RD/PPF/EPF)
   - Fill in details:
     - Bank/Institution name
     - Principal amount
     - Interest rate
     - Start date and tenure
     - Compounding frequency

3. **Track Returns**
   - View your portfolio on the Overview screen
   - See XIRR and absolute returns
   - Check individual investment details
   - Monitor payment history for RDs

### Exporting Your Data

1. Go to Profile → Account Actions
2. Tap "Export Data"
3. Review the export preview
4. Choose where to save the JSON file
5. Your complete investment data is backed up!

---

## 🎯 Current Capabilities

### ✅ What Works Great

- **Complete Investment Tracking** for FD, RD, PPF, EPF
- **Accurate Calculations** - XIRR, compound interest, maturity values
- **Beautiful UI** - Material Design 3 with smooth animations
- **Offline First** - Works completely without internet
- **Fast Performance** - Instant calculations and updates
- **Data Privacy** - Everything stays on your device

### ⚠️ Current Limitations

- **No Cloud Sync** - Data is device-local only (backup via export)
- **Single User** - One profile per installation
- **No Notifications** - Must manually check maturity dates
- **Limited Investment Types** - Stocks, mutual funds, crypto coming soon
- **No Tax Calculations** - Manual tax computation needed
- **No Budget Tracking** - Focus is on investments only

---

## 🔮 Coming Soon

We're actively working on these exciting features:

### 🎯 Short Term (Next Release)
- [ ] **Investment Reminders** - Notifications for maturity dates and payment due dates
- [ ] **CSV Export** - Export data in spreadsheet format
- [ ] **Multiple Profiles** - Switch between family member accounts
- [ ] **Category Tags** - Organize investments with custom tags

### 🚀 Medium Term (Q1 2026)
- [ ] **Mutual Funds** - SIP tracking with NAV updates
- [ ] **Stock Portfolio** - Track equity investments
- [ ] **Gold Investments** - Digital gold and sovereign gold bonds
- [ ] **Cloud Backup** - Optional encrypted cloud sync
- [ ] **Tax Helper** - Calculate tax implications

### 🌟 Long Term Vision
- [ ] **Cryptocurrency** - Track crypto holdings
- [ ] **Real Estate** - Property investment tracking
- [ ] **Goal Tracking** - Set and monitor financial goals
- [ ] **Budget Integration** - Track expenses alongside investments
- [ ] **AI Insights** - Smart recommendations
- [ ] **Multi-currency** - International investment support

---

## 🏦 Supported Banks

Pre-configured with branding for major Indian banks:
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

_Don't see your bank? You can add it manually when creating investments._

---

## 📖 Documentation

- **[Engineering Guide](docs/ENGINEERING.md)** - Architecture, code structure, development setup, and build automation
- **[Architecture Guide](docs/ARCHITECTURE_GUIDE.md)** - SOLID principles and design patterns

---

## 🤝 Contributing

We welcome contributions! Whether it's bug fixes, new features, or documentation improvements.

**How to Contribute:**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes with tests
4. Ensure all tests pass (`flutter test`)
5. Submit a Pull Request

See [ENGINEERING.md](docs/ENGINEERING.md) for development setup and coding standards.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

The "Saver" name, logo, and app store listing, as well as third-party bank names and logos in `assets/`, are not covered by this license and remain the property of their respective owners.

---

## 💬 Support

- **Bug Reports**: [Open an issue](https://github.com/avijitmondal/saver/issues)
- **Feature Requests**: [Discuss in issues](https://github.com/avijitmondal/saver/issues)
- **Questions**: Contact [@avijitmondal](https://github.com/avijitmondal)

---

## 🙏 Acknowledgments

Built with ❤️ using [Flutter](https://flutter.dev/)

Special thanks to:
- [fl_chart](https://github.com/imaNNeo/fl_chart) for beautiful portfolio charts
- The Flutter community for excellent packages and support
- All contributors and users providing feedback

---

**Made with Flutter** 🦋

