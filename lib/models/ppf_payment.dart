import 'package:flutter/material.dart';

/// Model class for PPF payments
class PPFPayment {
  /// The date when the payment was made or is scheduled
  final DateTime date;
  
  /// The amount of the payment
  final double amount;
  
  /// The status of the payment (e.g., 'Completed', 'Pending')
  final String status;
  
  /// Optional reference number for the payment
  final String? referenceNumber;
  
  /// Optional notes about the payment
  final String? notes;

  /// Constructor for PPFPayment
  const PPFPayment({
    required this.date,
    required this.amount,
    required this.status,
    this.referenceNumber,
    this.notes,
  });

  /// Create a PPFPayment from a map
  factory PPFPayment.fromMap(Map<String, dynamic> map) {
    return PPFPayment(
      date: map['date'] as DateTime,
      amount: map['amount'] as double,
      status: map['status'] as String,
      referenceNumber: map['referenceNumber'] as String?,
      notes: map['notes'] as String?,
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
    };
  }

  /// Check if the payment is completed
  bool get isCompleted => status == 'Completed';

  /// Check if the payment is pending
  bool get isPending => status == 'Pending';

  /// Create a copy of this PPFPayment with some fields replaced
  PPFPayment copyWith({
    DateTime? date,
    double? amount,
    String? status,
    String? referenceNumber,
    String? notes,
  }) {
    return PPFPayment(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
    );
  }
} 