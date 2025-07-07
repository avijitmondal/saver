import 'package:flutter/material.dart';

class RDPayment {
  final DateTime date;
  final double amount;
  final bool isCompleted;
  final String? referenceNumber;
  final String? notes;
  final PaymentStatus status;

  RDPayment({
    required this.date,
    required this.amount,
    this.isCompleted = true,
    this.referenceNumber,
    this.notes,
    this.status = PaymentStatus.completed,
  });

  // Factory constructor to create a payment from a map
  factory RDPayment.fromMap(Map<String, dynamic> map) {
    return RDPayment(
      date: map['date'],
      amount: map['amount'],
      isCompleted: map['isCompleted'] ?? true,
      referenceNumber: map['referenceNumber'],
      notes: map['notes'],
      status: map['status'] != null
          ? PaymentStatus.values.firstWhere(
              (e) => e.toString() == 'PaymentStatus.${map['status']}',
              orElse: () => PaymentStatus.completed,
            )
          : PaymentStatus.completed,
    );
  }

  // Convert payment to a map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
      'isCompleted': isCompleted,
      'referenceNumber': referenceNumber,
      'notes': notes,
      'status': status.toString().split('.').last,
    };
  }

  // Create a copy of this payment with given fields replaced with new values
  RDPayment copyWith({
    DateTime? date,
    double? amount,
    bool? isCompleted,
    String? referenceNumber,
    String? notes,
    PaymentStatus? status,
  }) {
    return RDPayment(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isCompleted: isCompleted ?? this.isCompleted,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}

enum PaymentStatus {
  completed,
  pending,
  failed,
  scheduled,
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.scheduled:
        return 'Scheduled';
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.scheduled:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.completed:
        return Icons.check_circle;
      case PaymentStatus.pending:
        return Icons.pending;
      case PaymentStatus.failed:
        return Icons.error;
      case PaymentStatus.scheduled:
        return Icons.schedule;
    }
  }
} 