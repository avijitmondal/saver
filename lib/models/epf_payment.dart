
/// Model class for EPF payments
class EPFPayment {
  /// The date when the payment was made or is scheduled
  final DateTime date;
  
  /// The amount of the payment
  final double amount;
  
  /// The status of the payment (e.g., 'Completed', 'Upcoming')
  final String status;
  
  /// Optional reference number for the payment
  final String? referenceNumber;
  
  /// Optional notes about the payment
  final String? notes;

  /// Constructor for EPFPayment
  const EPFPayment({
    required this.date,
    required this.amount,
    required this.status,
    this.referenceNumber,
    this.notes,
  });

  /// Create an EPFPayment from a map
  factory EPFPayment.fromMap(Map<String, dynamic> map) {
    return EPFPayment(
      date: map['date'] as DateTime,
      amount: map['amount'] as double,
      status: map['status'] as String,
      referenceNumber: map['referenceNumber'] as String?,
      notes: map['notes'] as String?,
    );
  }

  /// Convert an EPFPayment to a map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
      'status': status,
      'referenceNumber': referenceNumber,
      'notes': notes,
    };
  }

  /// Check if the payment is completed
  bool get isCompleted => status == 'Completed';

  /// Check if the payment is upcoming
  bool get isUpcoming => status == 'Upcoming';

  /// Create a copy of this EPFPayment with some fields replaced
  EPFPayment copyWith({
    DateTime? date,
    double? amount,
    String? status,
    String? referenceNumber,
    String? notes,
  }) {
    return EPFPayment(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
    );
  }
} 