import '../models/user.dart';

/// Interface for user data persistence following Repository Pattern
/// Enables dependency inversion and easier testing
abstract class UserRepository {
  /// Load user data from storage
  Future<User?> getUser();
  
  /// Save user data to storage
  Future<void> saveUser(User user);
  
  /// Delete user data from storage
  Future<void> deleteUser();
  
  /// Check if user data exists
  Future<bool> hasUser();
}
