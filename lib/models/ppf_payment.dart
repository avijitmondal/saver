
/// Model class for PPF payments
class PPFPayment {
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
  
  /// Whether this is a recurring payment
  final bool isRecurring;
  
  /// Frequency of recurring payment (e.g., 'Monthly', 'Quarterly', 'Yearly')
  final String? recurringFrequency;

  /// Constructor for PPFPayment
  const PPFPayment({
    required this.date,
    required this.amount,
    required this.status,
    this.referenceNumber,
    this.notes,
    this.isRecurring = false,
    this.recurringFrequency,
  });

  /// Create a PPFPayment from a map
  factory PPFPayment.fromMap(Map<String, dynamic> map) {
    return PPFPayment(
      date: map['date'] as DateTime,
      amount: map['amount'] as double,
      status: map['status'] as String,
      referenceNumber: map['referenceNumber'] as String?,
      notes: map['notes'] as String?,
      isRecurring: map['isRecurring'] as bool? ?? false,
      recurringFrequency: map['recurringFrequency'] as String?,
    );
  }

  /// Convert a PPFPayment to a map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
      'status': status,
      'referenceNumber': referenceNumber,
      'notes': notes,
      'isRecurring': isRecurring,
      'recurringFrequency': recurringFrequency,
    };
  }

  /// Check if the payment is completed
  bool get isCompleted => status == 'Completed';

  /// Check if the payment is upcoming
  bool get isUpcoming => status == 'Upcoming';

  /// Create a copy of this PPFPayment with some fields replaced
  PPFPayment copyWith({
    DateTime? date,
    double? amount,
    String? status,
    String? referenceNumber,
    String? notes,
    bool? isRecurring,
    String? recurringFrequency,
  }) {
    return PPFPayment(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
    );
  }
} 