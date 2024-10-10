import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task1/bloc/counter_bloc.dart';
import 'package:task1/bloc/counter_event.dart';
import 'package:task1/bloc/counter_state.dart';

class TransactionReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transaction Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: const Color(0xff4EC6F6), // Background color
              ),
              onPressed: () {
                BlocProvider.of<ReportBloc>(context).add(SelectFileEvent());
              },
              child: const Text(
                'Upload Excel File',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Start Time (Format: hh:mm:ss)',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Ex : 20:59:59',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              controller: startTimeController,
            ),
            SizedBox(height: 40),
            const Text(
              'End Time (Format: hh:mm:ss)',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextField(
              controller: endTimeController,
              decoration: const InputDecoration(
                hintText: 'Ex : 20:59:59',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: const Color(0xff4EC6F6), // Background color
              ),
              onPressed: () {
                String startTime = startTimeController.text;
                String endTime = endTimeController.text;
                BlocProvider.of<ReportBloc>(context).add(
                  CalculateTotalEvent(startTime: startTime, endTime: endTime),
                );
              },
              child: const Text(
                'Calculate Total',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is TotalCalculatedState) {
                  String formattedTotal =
                      NumberFormat('#,###').format(state.total);
                  return Text('Tổng tiền: $formattedTotal VND',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold));
                }
                if (state is ReportErrorState) {
                  return Column(
                    children: [
                      Text('Vui lòng nhập đúng định dạng ',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Error: ${state.message}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
