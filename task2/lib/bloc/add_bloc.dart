// transaction_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/bloc/add_event.dart';
import 'package:task2/bloc/add_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is SubmitTransaction) {
      // Kiểm tra dữ liệu (có thể tùy chỉnh thêm logic)
      if (event.quantity <= 0 || event.revenue < 0 || event.unitPrice < 0) {
        yield TransactionError('Giá trị không hợp lệ!');
      } else {
        yield TransactionSuccess('Cập nhật thành công!');
      }
    }
  }
}
