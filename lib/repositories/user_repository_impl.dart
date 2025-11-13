import '../models/user.dart';
import '../services/local_storage_service.dart';
import 'user_repository.dart';

/// Implementation of UserRepository using LocalStorageService
/// Follows Dependency Inversion Principle - depends on abstraction
class UserRepositoryImpl implements UserRepository {
  final LocalStorageService _storageService;

  UserRepositoryImpl(this._storageService);

  @override
  Future<User?> getUser() async {
    final userData = await _storageService.loadUserData();
    if (userData == null) return null;
    return User.fromMap(userData);
  }

  @override
  Future<void> saveUser(User user) async {
    await _storageService.saveUserData(user.toMap());
  }

  @override
  Future<void> deleteUser() async {
    await _storageService.clearAllData();
  }

  @override
  Future<bool> hasUser() async {
    return await _storageService.hasUserData();
  }
}
