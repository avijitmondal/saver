# Engineering Guide

Technical documentation for developers working on Saver.

---

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Development Setup](#development-setup)
- [Code Architecture](#code-architecture)
- [Testing Strategy](#testing-strategy)
- [Build & Deployment](#build--deployment)
- [Configuration](#configuration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## 🏗️ Architecture Overview

Saver follows **SOLID principles** and uses a **layered architecture** pattern for maintainability and testability.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│           UI Layer (Screens/Widgets)     │
│  - Stateless/Stateful Widgets            │
│  - Material Design Components            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Presentation Layer               │
│  - Controllers (Business Logic)          │
│  - Providers (State Management)          │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Domain Layer                    │
│  - Models (Investment, User)             │
│  - Value Objects (Email, Money, etc.)    │
│  - Repository Interfaces                 │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Service Layer                    │
│  - Business Services                     │
│  - Calculation Services                  │
│  - Data Transformation Services          │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Data Layer                       │
│  - Repository Implementations            │
│  - Storage Services (SharedPreferences)  │
└─────────────────────────────────────────┘
```

### Key Architectural Patterns

1. **Repository Pattern** - Abstracts data access layer
2. **Service Locator** - Centralized dependency injection using GetIt
3. **Provider Pattern** - Reactive state management
4. **Value Objects** - Domain-driven design for validation
5. **Dependency Injection** - Constructor-based injection for testability

For detailed architecture documentation, see [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md).

---

## 📁 Project Structure

```
saver/
├── lib/
│   ├── config/                    # App configuration
│   │   ├── provider_config.dart   # Provider setup
│   │   ├── route_config.dart      # Named routes
│   │   ├── service_locator.dart   # Dependency injection
│   │   └── theme_config.dart      # Material theme
│   │
│   ├── constants/                 # App-wide constants
│   │   ├── app_constants.dart     # Feature flags, app info
│   │   ├── bank_constants.dart    # Bank logos and colors
│   │   ├── investment_constants.dart  # Investment types
│   │   ├── notification_constants.dart
│   │   └── ui_constants.dart      # Spacing, sizing
│   │
│   ├── controllers/               # Business logic controllers
│   │   └── profile_controller.dart
│   │
│   ├── data/                      # Sample/seed data
│   │   └── sample_*.dart
│   │
│   ├── domain/                    # Domain layer
│   │   └── value_objects/         # DDD value objects
│   │       ├── email.dart
│   │       ├── phone_number.dart
│   │       ├── money.dart
│   │       └── interest_rate.dart
│   │
│   ├── models/                    # Data models
│   │   ├── investment.dart
│   │   └── user.dart
│   │
│   ├── providers/                 # State management
│   │   ├── user_provider.dart
│   │   ├── portfolio_provider.dart
│   │   ├── notifications_provider.dart
│   │   └── feature_flags_provider.dart
│   │
│   ├── repositories/              # Data access abstraction
│   │   ├── user_repository.dart           # Interface
│   │   ├── user_repository_impl.dart      # Implementation
│   │   ├── investment_repository.dart
│   │   └── investment_repository_impl.dart
│   │
│   ├── screens/                   # UI screens
│   │   ├── splash_screen.dart
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── overview_screen.dart
│   │   ├── investments_screen.dart
│   │   ├── profile_screen.dart
│   │   └── [investment_type]_screen.dart
│   │
│   ├── services/                  # Business services
│   │   ├── authentication_service.dart      # Password handling
│   │   ├── investment_filter_service.dart   # Filtering logic
│   │   ├── data_transformation_service.dart # Model conversion
│   │   ├── file_service.dart                # File operations
│   │   ├── data_export_service.dart         # Export functionality
│   │   ├── data_import_service.dart         # Import functionality
│   │   ├── investment_calculator.dart       # Financial calculations
│   │   ├── local_storage_service.dart       # SharedPreferences wrapper
│   │   ├── dialog_service.dart              # Dialog helpers
│   │   ├── navigation_service.dart          # Navigation helpers
│   │   └── account_manager.dart             # Account operations
│   │
│   ├── utils/                     # Helper utilities
│   │   ├── date_formatter.dart
│   │   ├── number_formatter.dart
│   │   ├── download_helper.dart
│   │   └── theme_helper.dart
│   │
│   └── widgets/                   # Reusable widgets
│       ├── common/                # Shared components
│       ├── profile/               # Profile-related widgets
│       └── [component]_card.dart  # Feature-specific widgets
│
├── test/                          # Test files (mirrors lib/)
│   ├── models/
│   ├── services/
│   ├── domain/
│   └── providers/
│
├── docs/                          # Documentation
│   ├── ENGINEERING.md             # This file
│   ├── ARCHITECTURE_GUIDE.md      # Architecture details
│   ├── REFACTORING.md             # Refactoring documentation
│   └── REFACTORING_SUMMARY.md     # Summary of changes
│
├── android/                       # Android platform code
├── ios/                          # iOS platform code
├── web/                          # Web platform code
└── pubspec.yaml                  # Dependencies
```

---

## 🛠️ Development Setup

### Prerequisites

- **Flutter SDK**: >=3.10.0
- **Dart SDK**: >=3.0.0
- **IDE**: VS Code or Android Studio with Flutter plugins
- **Git**: For version control

### Initial Setup

1. **Clone and install dependencies**
   ```bash
   git clone https://github.com/avijitmondal/saver.git
   cd saver
   flutter pub get
   ```

2. **Verify installation**
   ```bash
   flutter doctor -v
   ```

3. **Run in development mode**
   ```bash
   # With sample data (recommended for development)
   flutter run
   
   # With developer tools
   flutter run --dart-define=DEVELOPER_MODE=true
   ```

### IDE Setup

**VS Code Extensions:**
- Dart
- Flutter
- Flutter Widget Snippets
- Error Lens
- GitLens

**Android Studio Plugins:**
- Flutter
- Dart
- Flutter Intl

### Code Style

We use `flutter_lints` for consistent code style:

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - avoid_print
    - use_key_in_widget_constructors
```

Run linter:
```bash
flutter analyze
```

Auto-fix issues:
```bash
dart fix --apply
```

---

## 🏛️ Code Architecture

### SOLID Principles Implementation

#### 1. Single Responsibility Principle (SRP)
Each service has one focused responsibility:

```dart
// ✅ Good - Single responsibility
class AuthenticationService {
  String hashPassword(String password) { /* ... */ }
  bool validatePassword(String password, String hash) { /* ... */ }
}

class InvestmentFilterService {
  List<Investment> filterActive(List<Investment> investments) { /* ... */ }
  List<Investment> filterByType(List<Investment> investments, String type) { /* ... */ }
}

// ❌ Bad - Multiple responsibilities
class UserService {
  void saveUser() { /* storage */ }
  String hashPassword() { /* crypto */ }
  void sendEmail() { /* email */ }
}
```

#### 2. Open/Closed Principle (OCP)
Use interfaces for extensibility:

```dart
// Repository interfaces allow new implementations
abstract class InvestmentRepository {
  Future<List<Investment>> getAll();
  Future<void> add(Investment investment);
}

// Can swap implementations without breaking code
class InvestmentRepositoryImpl implements InvestmentRepository { /* ... */ }
class MockInvestmentRepository implements InvestmentRepository { /* ... */ }
```

#### 3. Dependency Inversion Principle (DIP)
Depend on abstractions, not concrete classes:

```dart
// ✅ Good - Depends on abstraction
class PortfolioProvider {
  final InvestmentRepository _repository;  // Interface
  PortfolioProvider({required InvestmentRepository repository})
    : _repository = repository;
}

// ❌ Bad - Depends on concrete class
class PortfolioProvider {
  final LocalStorageService _storage = LocalStorageService();
}
```

### State Management with Provider

```dart
// 1. Define Provider
class UserProvider extends ChangeNotifier {
  User? _user;
  
  Future<void> updateUserData({String? firstName}) async {
    // Update user
    _user = _user?.copyWith(firstName: firstName);
    notifyListeners();  // Trigger UI rebuild
  }
}

// 2. Register in Provider tree
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => serviceLocator.userProvider),
    ChangeNotifierProvider(create: (_) => serviceLocator.portfolioProvider),
  ],
  child: MyApp(),
)

// 3. Consume in widgets
class ProfileScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Text(userProvider.firstName);
  }
}
```

### Service Locator Pattern

```dart
// Setup (in main.dart)
void main() async {
  await setupLocator();
  runApp(MyApp());
}

// Registration (in service_locator.dart)
final locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => InvestmentFilterService());
  
  // Repositories
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<LocalStorageService>())
  );
  
  // Providers
  locator.registerLazySingleton(() => UserProvider(
    repository: locator<UserRepository>(),
    authService: locator<AuthenticationService>(),
  ));
}

// Usage
final exportService = locator<DataExportService>();
```

### Value Objects (Domain-Driven Design)

```dart
// Encapsulate validation in value objects
class Email {
  final String value;
  
  Email(String email) : value = email {
    if (!_isValid(email)) {
      throw ArgumentError('Invalid email address');
    }
  }
  
  static bool _isValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }
  
  static Email? tryParse(String? email) {
    if (email == null) return null;
    try {
      return Email(email);
    } catch (_) {
      return null;
    }
  }
}

// Usage
final email = Email('user@example.com');  // ✅ Valid
final invalid = Email('invalid');          // ❌ Throws ArgumentError

final safe = Email.tryParse(userInput);   // Returns null if invalid
```

---

## 🧪 Testing Strategy

### Test Structure

```
test/
├── models/                        # Model tests
│   ├── investment_test.dart
│   └── user_test.dart
├── services/                      # Service tests
│   ├── authentication_service_test.dart
│   ├── data_export_service_test.dart
│   └── investment_calculator_test.dart
├── domain/                        # Value object tests
│   └── value_objects_test.dart
├── providers/                     # Provider tests
│   ├── user_provider_test.dart
│   └── portfolio_provider_test.dart
└── widget_test.dart              # Widget tests
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/investment_test.dart

# Run with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Writing Tests

```dart
// Unit test example
void main() {
  group('AuthenticationService', () {
    late AuthenticationService service;
    
    setUp(() {
      service = AuthenticationService();
    });
    
    test('should hash password correctly', () {
      final hash = service.hashPassword('password123');
      expect(hash, isNotEmpty);
      expect(hash, isNot(equals('password123')));
    });
    
    test('should validate correct password', () {
      final hash = service.hashPassword('password123');
      expect(service.validatePassword('password123', hash), isTrue);
    });
  });
}

// Provider test with mock
void main() {
  group('UserProvider', () {
    late UserProvider provider;
    late MockUserRepository mockRepo;
    
    setUp(() {
      mockRepo = MockUserRepository();
      provider = UserProvider(
        repository: mockRepo,
        authService: AuthenticationService(),
      );
    });
    
    test('should update user data', () async {
      await provider.updateUserData(firstName: 'John');
      expect(provider.firstName, equals('John'));
    });
  });
}
```

### Test Coverage Goals

- **Models**: 90%+ coverage
- **Services**: 85%+ coverage
- **Providers**: 80%+ coverage
- **Overall**: 80%+ coverage

Current coverage: **~90%** on core models

---

## 🚀 Build & Deployment

### Release Builds

Release builds are produced with the standard Flutter tooling (see [Production Builds](#production-builds)). Android release signing reads the following environment variables; without them the build falls back to debug signing:

- `ANDROID_KEY_STORE_FILE`
- `ANDROID_KEY_STORE_ALIAS`
- `ANDROID_STORE_PASSWORD`
- `ANDROID_KEY_PASSWORD`

Never commit keystores or credentials to version control.

**Web:**  
This project uses a static HTML website (`docs/web/`) instead of Flutter web. Deploy the static content with your preferred hosting.

**iOS:**  
Use [Fastlane](https://fastlane.tools/) or Xcode for App Store deployment.

#### CI/CD Integration

GitHub Actions workflows build and test the app:
- [.github/workflows/build-android.yml](../.github/workflows/build-android.yml)
- [.github/workflows/build-ios.yml](../.github/workflows/build-ios.yml)

Workflows automatically:
1. Checkout the repository
2. Set up Flutter (and Java for Android)
3. Run tests
4. Build the app

### Environment Configuration

#### Compile-Time Flags

```dart
// Access in code
const bool useSampleData = bool.fromEnvironment('SAMPLE_DATA', defaultValue: true);
const bool developerMode = bool.fromEnvironment('DEVELOPER_MODE', defaultValue: false);
```

| Flag | Default | Purpose |
|------|---------|---------|
| `SAMPLE_DATA` | `true` | Load sample investments and user data |
| `DEVELOPER_MODE` | `false` | Show advanced settings in profile |

#### Runtime Feature Flags

```dart
// lib/constants/app_constants.dart
static final Map<string, bool> featureFlags = {
  'fixedDepositInvestment': true,
  'recurringDepositInvestment': true,
  'publicProvidentFundInvestment': true,
  'employeeProvidentFundInvestment': true,
  'mutualFundInvestment': false,      // Coming soon
  'stockInvestment': false,            // Coming soon
  'notifications': false,
};
```

### Build Commands

#### Development Builds

```bash
# Debug build with hot reload
flutter run

# With specific flags
flutter run \
  --dart-define=SAMPLE_DATA=true \
  --dart-define=DEVELOPER_MODE=true
```

#### Production Builds

```bash
# Android (AAB for Play Store)
flutter build appbundle \
  --dart-define=SAMPLE_DATA=false \
  --dart-define=DEVELOPER_MODE=false

# Android (APK for direct install)
flutter build apk --release \
  --dart-define=SAMPLE_DATA=false \
  --dart-define=DEVELOPER_MODE=false

# iOS
flutter build ipa \
  --dart-define=SAMPLE_DATA=false \
  --dart-define=DEVELOPER_MODE=false

# Web
flutter build web --release \
  --dart-define=SAMPLE_DATA=false \
  --dart-define=DEVELOPER_MODE=false
```

### Build Outputs

| Platform | Output Location |
|----------|----------------|
| Android AAB | `build/app/outputs/bundle/release/app-release.aab` |
| Android APK | `build/app/outputs/flutter-apk/app-release.apk` |
| iOS | `build/ios/ipa/` |
| Web | `build/web/` |

---

## ⚙️ Configuration

### App Constants

```dart
// lib/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Saver';
  static const String appVersion = '1.0.3';
  
  // Environment-based configuration
  static const bool useSampleData = bool.fromEnvironment('SAMPLE_DATA', defaultValue: true);
  static const bool developerMode = bool.fromEnvironment('DEVELOPER_MODE', defaultValue: false);
  
  // Feature flags
  static final Map<String, bool> featureFlags = { /* ... */ };
}
```

### Adding New Investment Types

1. **Add to constants:**
   ```dart
   // lib/constants/investment_constants.dart
   static const List<InvestmentType> allTypes = [
     // ... existing types
     InvestmentType(
       name: 'Mutual Fund',
       icon: Icons.trending_up,
       color: Colors.purple,
     ),
   ];
   ```

2. **Add feature flag:**
   ```dart
   // lib/constants/app_constants.dart
   'mutualFundInvestment': true,
   ```

3. **Create screen:**
   ```dart
   // lib/screens/mutual_fund_screen.dart
   class MutualFundScreen extends StatelessWidget {
     // Implementation
   }
   ```

4. **Add to navigation:**
   ```dart
   // lib/config/route_config.dart
   static const String mutualFund = '/mutual-fund';
   ```

### Adding New Banks

```dart
// lib/constants/bank_constants.dart
static const Map<String, BankInfo> banks = {
  'Bank Name': BankInfo(
    name: 'Bank Name',
    color: Color(0xFF1234AB),
    logo: 'assets/banks/bank_logo.png',  // Optional
  ),
};
```

---

## ✅ Best Practices

### Code Style

1. **Use const constructors** where possible
   ```dart
   const Text('Hello');  // ✅ Good
   Text('Hello');         // ⚠️ Prefer const
   ```

2. **Prefer final over var**
   ```dart
   final name = 'John';   // ✅ Good
   var name = 'John';     // ⚠️ Use final
   ```

3. **Avoid print() in production**
   ```dart
   // ❌ Bad
   print('Debug info');
   
   // ✅ Good - use debugPrint or proper logging
   debugPrint('Debug info');
   ```

4. **Use meaningful names**
   ```dart
   // ❌ Bad
   var x = getUserData();
   
   // ✅ Good
   final currentUser = getUserData();
   ```

### Widget Organization

```dart
// Separate business logic from UI
class InvestmentCard extends StatelessWidget {
  final Investment investment;
  
  const InvestmentCard({super.key, required this.investment});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(),
          _buildDetails(),
          _buildActions(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() { /* ... */ }
  Widget _buildDetails() { /* ... */ }
  Widget _buildActions() { /* ... */ }
}
```

### Error Handling

```dart
// Always handle errors gracefully
Future<void> loadData() async {
  try {
    final data = await repository.getData();
    // Process data
  } catch (e) {
    // Log error
    debugPrint('Error loading data: $e');
    // Show user-friendly message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data')),
      );
    }
  }
}
```

### Async Operations

```dart
// Always check if widget is still mounted
Future<void> updateData() async {
  final result = await someAsyncOperation();
  
  if (!mounted) return;  // Widget might be disposed
  
  setState(() {
    data = result;
  });
}
```

---

## 🔧 Troubleshooting

### Common Issues

**1. Build failures after git pull**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**2. Platform-specific build errors**
```bash
# Android
cd android
./gradlew clean
cd ..

# iOS
cd ios
pod deintegrate
pod install
cd ..
```

**3. Provider not found errors**
```dart
// Ensure provider is registered in main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
  ],
)

// Use correct context (not from Builder)
final provider = context.watch<UserProvider>();  // ✅
```

**4. Service locator errors**
```dart
// Ensure setupLocator() is called in main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();  // ← Required
  runApp(MyApp());
}
```

### Debug Mode

Enable developer mode for additional debugging:
```bash
flutter run --dart-define=DEVELOPER_MODE=true
```

This shows:
- Advanced settings in profile
- Additional logging
- Debug information

### Performance Profiling

```bash
# Run in profile mode
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)
- [GetIt (Service Locator)](https://pub.dev/packages/get_it)

### Internal Documentation

- **[ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md)** - Detailed architecture patterns
- **[REFACTORING.md](REFACTORING.md)** - Refactoring history and decisions
- **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)** - Quick summary of changes

---

## 🤝 Contributing Guidelines

1. **Create feature branch** from `main`
2. **Follow code style** (enforced by linter)
3. **Write tests** for new features
4. **Update documentation** for API changes
5. **Run tests** before committing: `flutter test`
6. **Keep commits atomic** with clear messages
7. **Request review** via Pull Request

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(investments): add mutual fund support

- Add MutualFund model
- Create mutual fund screen
- Implement SIP calculations

Closes #123
```

---

**Last Updated**: November 2025  
**Maintainer**: [@avijitmondal](https://github.com/avijitmondal)
