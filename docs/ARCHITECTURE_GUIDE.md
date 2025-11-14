# Architecture Guide

## Overview

Saver is built using Flutter following clean architecture principles, SOLID design patterns, and best practices for maintainable, testable code.

## Architecture Layers

### 1. Presentation Layer
**Location**: `lib/screens/`, `lib/widgets/`

Responsible for UI and user interaction.

- **Screens**: Full-page views (e.g., `home_screen.dart`, `investments_screen.dart`)
- **Widgets**: Reusable UI components (e.g., `investment_card.dart`, `portfolio_summary_card.dart`)
- **Controllers**: Business logic controllers (e.g., `profile_controller.dart`)

**Key Principles:**
- Widgets are stateless or stateful based on need
- Use Provider for state management
- Separation of UI from business logic

### 2. Business Logic Layer
**Location**: `lib/providers/`, `lib/controllers/`

Manages application state and business rules.

- **Providers**: State management using ChangeNotifier (e.g., `PortfolioProvider`, `UserProvider`)
- **Controllers**: Coordinate complex operations (e.g., `ProfileController`)

**Key Principles:**
- Single Responsibility Principle (SRP)
- Providers manage specific domains
- Notify listeners on state changes

### 3. Domain Layer
**Location**: `lib/models/`

Contains business entities and value objects.

- **Models**: Core entities (e.g., `Investment`, `User`)
- **Value Objects**: Immutable domain primitives (e.g., `Email`, `Money`, `InterestRate`)

**Key Principles:**
- Immutable where possible
- Rich domain models with behavior
- Type safety through value objects

### 4. Data Layer
**Location**: `lib/data/repositories/`, `lib/services/`

Handles data persistence and external services.

- **Repositories**: Data access abstraction (e.g., `InvestmentRepository`, `UserRepository`)
- **Services**: Specialized services (e.g., `DataExportService`, `AuthenticationService`)

**Key Principles:**
- Repository pattern for data access
- Service layer for complex operations
- Dependency injection via GetIt

## SOLID Principles

### Single Responsibility Principle (SRP)
Each class has one reason to change.

**Example:**
- `InvestmentRepository` - Only handles investment data persistence
- `DataExportService` - Only handles exporting data
- `InvestmentFilterService` - Only handles filtering logic

### Open/Closed Principle (OCP)
Open for extension, closed for modification.

**Example:**
- `Investment` model supports different types without modification
- Value objects extend behavior without changing core classes

### Liskov Substitution Principle (LSP)
Subtypes must be substitutable for their base types.

**Example:**
- All repositories implement consistent interfaces
- Value objects can be used interchangeably with their primitives

### Interface Segregation Principle (ISP)
No client should depend on methods it doesn't use.

**Example:**
- Small, focused service interfaces
- Providers expose only necessary methods

### Dependency Inversion Principle (DIP)
Depend on abstractions, not concretions.

**Example:**
- Providers depend on repository interfaces, not implementations
- Service Locator (GetIt) manages dependencies
- Controllers receive dependencies via constructor injection

## Design Patterns

### 1. Repository Pattern
**Purpose**: Abstraction over data sources

**Implementation:**
```dart
abstract class InvestmentRepository {
  Future<List<Investment>> getAll();
  Future<void> save(Investment investment);
  Future<void> delete(String id);
}
```

**Benefits:**
- Decouples business logic from data access
- Easy to test with mock repositories
- Can swap storage implementations

### 2. Provider Pattern (State Management)
**Purpose**: Reactive state management

**Implementation:**
```dart
class PortfolioProvider extends ChangeNotifier {
  List<Investment> _investments = [];
  
  void addInvestment(Investment investment) {
    _investments.add(investment);
    notifyListeners();
  }
}
```

**Benefits:**
- Efficient rebuilds
- Type-safe
- Easy to test

### 3. Service Locator Pattern
**Purpose**: Dependency injection

**Implementation:**
```dart
final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DataExportService>(
    () => DataExportService(),
  );
}
```

**Benefits:**
- Loose coupling
- Easy to mock for testing
- Centralized dependency management

### 4. Value Object Pattern
**Purpose**: Domain-driven design primitives

**Implementation:**
```dart
class Email {
  final String value;
  
  Email._(this.value);
  
  factory Email.create(String value) {
    if (!_isValid(value)) {
      throw ArgumentError('Invalid email');
    }
    return Email._(value);
  }
}
```

**Benefits:**
- Type safety
- Validation at creation
- Immutability
- Self-documenting code

### 5. Factory Pattern
**Purpose**: Object creation abstraction

**Implementation:**
```dart
class User {
  factory User.create({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return User._(
      id: Uuid().v4(),
      firstName: firstName,
      lastName: lastName,
      email: Email.create(email),
      createdAt: DateTime.now(),
    );
  }
}
```

**Benefits:**
- Encapsulates creation logic
- Validation during construction
- Flexible instantiation

## State Management

### Provider Architecture

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens & Widgets)                    │
│  ┌─────────────────────────────────┐   │
│  │  Consumer<PortfolioProvider>    │   │
│  │  - Rebuilds on changes          │   │
│  └─────────────────────────────────┘   │
└──────────────────┬──────────────────────┘
                   │ notifyListeners()
┌──────────────────▼──────────────────────┐
│         Business Logic Layer            │
│  (Providers)                            │
│  ┌─────────────────────────────────┐   │
│  │  PortfolioProvider              │   │
│  │  - Manages investments          │   │
│  │  - Calculates returns           │   │
│  └─────────────────────────────────┘   │
└──────────────────┬──────────────────────┘
                   │ Repository calls
┌──────────────────▼──────────────────────┐
│            Data Layer                   │
│  (Repositories & Services)              │
│  ┌─────────────────────────────────┐   │
│  │  InvestmentRepository           │   │
│  │  - SharedPreferences            │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

### Key Providers

1. **PortfolioProvider**
   - Manages investment collection
   - Calculates portfolio metrics
   - Filters by feature flags

2. **UserProvider**
   - User authentication state
   - Profile information
   - Preferences

3. **FeatureFlagsProvider**
   - Runtime feature toggles
   - Type-safe enum API
   - Category grouping

## Data Flow

### Adding an Investment

```
User Input (Screen)
    ↓
Validation (Controller/Provider)
    ↓
Create Domain Model (Investment)
    ↓
Save to Repository (InvestmentRepository)
    ↓
Update Provider State (PortfolioProvider)
    ↓
Notify Listeners
    ↓
UI Rebuilds (Consumer widgets)
```

### Reading Portfolio Data

```
Widget Build
    ↓
context.watch<PortfolioProvider>()
    ↓
Provider applies filters (FeatureFlags)
    ↓
Calculates metrics (XIRR, Returns)
    ↓
Returns data to widget
    ↓
Widget renders
```

## Testing Strategy

### Unit Tests
**Location**: `test/models/`, `test/services/`, `test/providers/`

Test individual components in isolation.

**Example:**
```dart
test('Email validation rejects invalid format', () {
  expect(
    () => Email.create('invalid'),
    throwsA(isA<ArgumentError>()),
  );
});
```

### Widget Tests
**Location**: `test/widgets/`

Test UI components.

**Example:**
```dart
testWidgets('InvestmentCard displays amount', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: InvestmentCard(investment: testInvestment),
    ),
  );
  
  expect(find.text('₹10,000'), findsOneWidget);
});
```

### Integration Tests
**Location**: `test_driver/`

Test complete user flows.

## Feature Flags

### Configuration
**Location**: `lib/config/feature_flags_config.dart`

Type-safe enum-based feature flags.

```dart
enum FeatureFlag {
  notifications,
  fixedDepositInvestment,
  recurringDepositInvestment,
  // ... more flags
}
```

### Usage
```dart
final provider = context.read<FeatureFlagsProvider>();

if (provider.isEnabled(FeatureFlag.notifications)) {
  // Show notifications feature
}
```

### Benefits
- Runtime feature toggling
- A/B testing support
- Gradual rollouts
- Type safety

## Code Organization

```
lib/
├── config/              # App configuration
│   ├── feature_flags_config.dart
│   ├── route_config.dart
│   └── theme_config.dart
├── constants/           # App-wide constants
│   ├── app_constants.dart
│   ├── bank_constants.dart
│   └── investment_constants.dart
├── controllers/         # Business logic controllers
│   └── profile_controller.dart
├── data/
│   └── repositories/    # Data access layer
│       ├── investment_repository.dart
│       └── user_repository.dart
├── models/              # Domain entities
│   ├── investment.dart
│   ├── user.dart
│   └── value_objects/   # Value objects
│       ├── email.dart
│       ├── money.dart
│       └── interest_rate.dart
├── providers/           # State management
│   ├── portfolio_provider.dart
│   ├── user_provider.dart
│   └── feature_flags_provider.dart
├── screens/             # Full-page views
│   ├── home_screen.dart
│   ├── investments_screen.dart
│   └── ...
├── services/            # Business services
│   ├── authentication_service.dart
│   ├── data_export_service.dart
│   └── investment_filter_service.dart
├── utils/               # Utilities
│   ├── number_formatter.dart
│   └── investment_calculator.dart
└── widgets/             # Reusable UI components
    ├── investment_card.dart
    └── portfolio_summary_card.dart
```

## Best Practices

### 1. Immutability
Prefer immutable data structures:
```dart
class Investment {
  final String id;
  final double amount;
  final DateTime startDate;
  
  const Investment({
    required this.id,
    required this.amount,
    required this.startDate,
  });
}
```

### 2. Named Constructors
Use factory constructors for creation:
```dart
factory User.create({required String email}) {
  return User._(
    id: Uuid().v4(),
    email: Email.create(email),
  );
}
```

### 3. Extension Methods
Enhance types without modification:
```dart
extension DateTimeX on DateTime {
  bool isAfterToday() => isAfter(DateTime.now());
}
```

### 4. Null Safety
Leverage Dart's null safety:
```dart
String? nullableValue;
String nonNullValue = nullableValue ?? 'default';
```

### 5. Type Safety
Use enums and value objects:
```dart
enum InvestmentType { fixedDeposit, recurringDeposit }

class Money {
  final double amount;
  Money(this.amount) : assert(amount >= 0);
}
```

## Performance Optimization

### 1. Const Constructors
Use `const` for immutable widgets:
```dart
const Text('Hello')
```

### 2. Selective Rebuilds
Use `Consumer` for targeted updates:
```dart
Consumer<PortfolioProvider>(
  builder: (context, portfolio, child) {
    return Text(portfolio.total.toString());
  },
)
```

### 3. Lazy Loading
Load data on demand:
```dart
late final DataExportService _exportService = 
  locator<DataExportService>();
```

### 4. Memoization
Cache expensive calculations:
```dart
double? _cachedXirr;
double get xirr => _cachedXirr ??= calculateXirr();
```

## Security Considerations

1. **Data Encryption**: User data stored securely
2. **Password Hashing**: SHA-256 with salt
3. **Input Validation**: All user inputs validated
4. **No External APIs**: Data stays on device
5. **Secure Storage**: Uses platform-specific secure storage

## Future Architecture Improvements

1. **Clean Architecture**: Further separation of layers
2. **BLoC Pattern**: Consider for complex state
3. **Repository Caching**: Add caching layer
4. **Offline-First**: Sync when online
5. **Modular Features**: Feature-based architecture
6. **Error Handling**: Centralized error management
7. **Logging**: Structured logging system

## References

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Provider Documentation](https://pub.dev/packages/provider)
