import 'package:get_it/get_it.dart';
import 'navigation_service.dart';
import 'account_manager.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/notifications_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AccountManager());

  // Providers
  locator.registerLazySingleton(() => UserProvider());
  locator.registerLazySingleton(() => PortfolioProvider());
  locator.registerLazySingleton(() => NotificationsProvider());

  // Repositories (if applicable)
  // locator.registerLazySingleton(() => UserRepository());

  // Use Cases (if applicable)
  // locator.registerLazySingleton(() => GetUserUseCase(locator()));
}
