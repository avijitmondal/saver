import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../repositories/investment_repository.dart';
import '../repositories/investment_repository_impl.dart';
import '../services/local_storage_service.dart';
import '../services/investment_storage_factory.dart';
import '../services/authentication_service.dart';
import '../services/investment_filter_service.dart';
import '../services/data_transformation_service.dart';
import '../services/file_service.dart';
import '../services/data_export_service.dart';
import '../services/data_import_service.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';

/// Dependency Injection Container
/// Centralized place to create and manage dependencies
/// Follows Dependency Inversion Principle
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Services (singletons)
  late final AuthenticationService authService;
  late final InvestmentFilterService filterService;
  late final DataTransformationService transformationService;
  late final FileService fileService;
  late final DataExportService exportService;
  late final DataImportService importService;

  // Repositories (singletons)
  late final UserRepository userRepository;
  late final InvestmentRepository investmentRepository;

  // Providers (singletons)
  late final UserProvider userProvider;
  late final PortfolioProvider portfolioProvider;

  bool _initialized = false;

  /// Initialize all dependencies
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize services (stateless, can be created immediately)
    authService = AuthenticationService();
    filterService = InvestmentFilterService();
    transformationService = DataTransformationService();
    fileService = FileService();
    
    exportService = DataExportService(
      transformationService: transformationService,
      filterService: filterService,
      fileService: fileService,
    );
    
    importService = DataImportService(
      transformationService: transformationService,
      fileService: fileService,
    );

    // Initialize storage services
    final localStorage = await LocalStorageService.getInstance();
    final investmentStorage = await InvestmentStorageFactory.create();

    // Initialize repositories
    userRepository = UserRepositoryImpl(localStorage);
    investmentRepository = InvestmentRepositoryImpl(investmentStorage);

    // Initialize providers
    userProvider = UserProvider(
      repository: userRepository,
      authService: authService,
    );

    portfolioProvider = PortfolioProvider(
      repository: investmentRepository,
      filterService: filterService,
    );

    _initialized = true;
  }

  /// Reset all dependencies (useful for testing)
  void reset() {
    _initialized = false;
  }

  /// Check if initialized
  bool get isInitialized => _initialized;
}

// Global instance for easy access
final serviceLocator = ServiceLocator();
