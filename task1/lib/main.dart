import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/bloc/counter_bloc.dart';
import 'package:task1/query_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Report',
      home: BlocProvider(
        create: (context) => ReportBloc(), // Tạo instance của ReportBloc
        child: TransactionReportScreen(), // Widget sử dụng ReportBloc
      ),
    );
  }
}
