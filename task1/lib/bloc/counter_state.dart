import 'package:equatable/equatable.dart';

// State cơ bản của Report
abstract class ReportState extends Equatable {
  const ReportState();
}

// State ban đầu khi chưa có file hoặc dữ liệu nào
class ReportInitialState extends ReportState {
  @override
  List<Object> get props => [];
}

// State khi tổng thành tiền được tính toán xong
class TotalCalculatedState extends ReportState {
  final double total;

  TotalCalculatedState({required this.total});

  @override
  List<Object> get props => [total];
}

// State khi có lỗi xảy ra
class ReportErrorState extends ReportState {
  final String message;

  ReportErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
