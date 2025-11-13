import 'package:get_it/get_it.dart';
import 'navigation_service.dart';
import 'account_manager.dart';
import 'local_storage_service.dart';
import 'investment_storage_factory.dart';
import 'authentication_service.dart';
import 'investment_filter_service.dart';
import 'data_transformation_service.dart';
import 'file_service.dart';
import 'data_export_service.dart';
import 'data_import_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../repositories/investment_repository.dart';
import '../repositories/investment_repository_impl.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/notifications_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Core Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AccountManager());

  // Business Logic Services
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => InvestmentFilterService());
  locator.registerLazySingleton(() => DataTransformationService());
  locator.registerLazySingleton(() => FileService());
  
  // Composite Services (depend on other services)
  locator.registerLazySingleton(() => DataExportService(
    transformationService: locator<DataTransformationService>(),
    filterService: locator<InvestmentFilterService>(),
    fileService: locator<FileService>(),
  ));
  
  locator.registerLazySingleton(() => DataImportService(
    transformationService: locator<DataTransformationService>(),
    fileService: locator<FileService>(),
  ));

  // Note: Repositories are registered asynchronously in setupLocatorAsync()
  // because they depend on async initialization of storage services
}

/// Async setup for components that require async initialization
Future<void> setupLocatorAsync() async {
  // Initialize storage services
  final localStorage = await LocalStorageService.getInstance();
  final investmentStorage = await InvestmentStorageFactory.create();

  // Register Repositories
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localStorage),
  );
  
  locator.registerLazySingleton<InvestmentRepository>(
    () => InvestmentRepositoryImpl(investmentStorage),
  );

  // Register Providers (depend on repositories)
  locator.registerLazySingleton(() => UserProvider(
    repository: locator<UserRepository>(),
    authService: locator<AuthenticationService>(),
  ));
  
  locator.registerLazySingleton(() => PortfolioProvider(
    repository: locator<InvestmentRepository>(),
    filterService: locator<InvestmentFilterService>(),
  ));
  
  locator.registerLazySingleton(() => NotificationsProvider());
}
