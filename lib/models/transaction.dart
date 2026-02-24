import '../enums/transaction_type.enum.dart';

class Transaction {
  final String transactionId;
  final String booking; // Assuming ID reference
  final TransactionType type;
  final double amount;
  final String sender;
  final String recipient;
  final String status;
  final DateTime createdAt;

  Transaction({
    required this.transactionId,
    required this.booking,
    required this.type,
    required this.amount,
    required this.sender,
    required this.recipient,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      booking: json['booking'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: (json['amount'] as num).toDouble(),
      sender: json['sender'],
      recipient: json['recipient'],
      status: json['Status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'booking': booking,
      'type': type.name,
      'amount': amount,
      'sender': sender,
      'recipient': recipient,
      'Status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
