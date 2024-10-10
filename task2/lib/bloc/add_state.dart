// transaction_state.dart
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final String message;

  TransactionSuccess(this.message);
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}
