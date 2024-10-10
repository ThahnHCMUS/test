import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:task1/bloc/counter_event.dart';
import 'package:task1/bloc/counter_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  File? reportFile;

  ReportBloc() : super(ReportInitialState()) {
    on<SelectFileEvent>(_onSelectFile);
    on<CalculateTotalEvent>(_onCalculateTotal);
  }

  void _onSelectFile(SelectFileEvent event, Emitter<ReportState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        reportFile = File(result.files.single.path!);
      }
    } catch (e) {
      emit(ReportErrorState(message: 'File selection failed'));
    }
  }

  void _onCalculateTotal(
      CalculateTotalEvent event, Emitter<ReportState> emit) async {
    if (reportFile == null) {
      emit(ReportErrorState(message: 'No file selected'));
      return;
    }

    try {
      // Đọc file Excel
      var bytes = reportFile!.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first]!;

      DateFormat timeFormat = DateFormat('HH:mm:ss');
      DateTime startTime = timeFormat.parse(event.startTime);
      DateTime endTime = timeFormat.parse(event.endTime);

      double total = 0;

      // Duyệt qua từng hàng trong file Excel
      for (var row in sheet.rows.skip(1)) {
        // Bỏ qua tiêu đề
        var transactionTimeCell = row[2]; // Cột Giờ là cột thứ 3 (index 2)
        var totalAmountCell =
            row[8]; // Cột Thành tiền (VNĐ) là cột thứ 8 (index 7)

        // Kiểm tra nếu cột Giờ hoặc Thành tiền bị null
        if (transactionTimeCell == null || totalAmountCell == null) {
          continue; // Bỏ qua hàng này nếu bất kỳ ô nào bị null
        }

        String transactionTime =
            transactionTimeCell.value.toString(); // Lấy giá trị giờ
        String totalAmount =
            totalAmountCell.value.toString(); // Lấy giá trị thành tiền

        DateTime transactionDateTime;

        // Xử lý lỗi khi chuyển đổi thời gian
        try {
          transactionDateTime = timeFormat.parse(transactionTime);
        } catch (e) {
          // Nếu không thể parse thời gian, bỏ qua hàng này
          continue;
        }

        // Kiểm tra nếu giao dịch trong khoảng thời gian yêu cầu
        if (transactionDateTime.isAfter(startTime) &&
            transactionDateTime.isBefore(endTime)) {
          // Loại bỏ dấu phẩy (nếu có) trong số tiền trước khi chuyển sang double
          totalAmount = totalAmount.replaceAll(',', '');
          double transactionTotal = double.parse(totalAmount);
          total += transactionTotal;
        }
      }

      // Trả về tổng số tiền tính toán được
      emit(TotalCalculatedState(total: total));
    } catch (e) {
      emit(ReportErrorState(message: 'Error calculating total: $e'));
    }
  }
}
