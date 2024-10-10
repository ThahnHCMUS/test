import 'package:equatable/equatable.dart';

// Event cơ bản cho Report
abstract class ReportEvent extends Equatable {
  const ReportEvent();
}

// Event cho việc chọn file
class SelectFileEvent extends ReportEvent {
  @override
  List<Object> get props => [];
}

// Event cho việc tính tổng tiền
class CalculateTotalEvent extends ReportEvent {
  final String startTime;
  final String endTime;

  CalculateTotalEvent({required this.startTime, required this.endTime});

  @override
  List<Object> get props => [startTime, endTime];
}
