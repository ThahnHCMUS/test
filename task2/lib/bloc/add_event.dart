// transaction_event.dart
abstract class TransactionEvent {}

class SubmitTransaction extends TransactionEvent {
  final DateTime transactionTime;
  final double quantity;
  final String pump;
  final double revenue;
  final double unitPrice;

  SubmitTransaction({
    required this.transactionTime,
    required this.quantity,
    required this.pump,
    required this.revenue,
    required this.unitPrice,
  });
}
