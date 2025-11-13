import '../models/investment.dart';
import '../models/user.dart';

/// Service for converting domain models to export format
/// Follows Single Responsibility Principle - only handles data transformation
class DataTransformationService {
  /// Convert User to export format (excludes sensitive data)
  Map<String, dynamic> userToExportMap(User user) {
    return {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phone': user.phone,
      'address': user.address,
      'dateOfBirth': user.dateOfBirth.toIso8601String(),
    };
  }

  /// Convert Investment to export format (excludes calculated values)
  Map<String, dynamic> investmentToExportMap(Investment investment) {
    return {
      'id': investment.id,
      'type': investment.type,
      'amount': investment.amount,
      'interest': investment.interest,
      'bank': investment.bank,
      'startDate': investment.startDate?.toIso8601String(),
      'durationInMonths': investment.durationInMonths,
      'compoundingFrequency': investment.compoundingFrequency,
      'isRecurring': investment.isRecurring,
      'notes': investment.notes,
      'iconCodePoint': investment.icon.codePoint,
      'colorValue': investment.color.value,
    };
  }

  /// Convert import data to User model
  User? importDataToUser(Map<String, dynamic> userData) {
    try {
      // Convert ISO date string back to DateTime
      if (userData['dateOfBirth'] != null) {
        userData['dateOfBirth'] = 
            DateTime.parse(userData['dateOfBirth']).millisecondsSinceEpoch;
      }
      return User.fromMap(userData);
    } catch (e) {
      return null;
    }
  }

  /// Convert import data to Investment model
  Investment? importDataToInvestment(Map<String, dynamic> invMap) {
    try {
      // Convert ISO date strings back to milliseconds
      if (invMap['startDate'] != null) {
        invMap['startDate'] = 
            DateTime.parse(invMap['startDate']).millisecondsSinceEpoch;
      }
      return Investment.fromMap(invMap);
    } catch (e) {
      return null;
    }
  }
}
