import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/add_screen.dart';
import 'package:task2/bloc/add_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction Report',
      home: BlocProvider(
        create: (context) => TransactionBloc(), // Tạo instance của ReportBloc
        child: TransactionEntryPage(), // Widget sử dụng ReportBloc
      ),
    );
  }
}
