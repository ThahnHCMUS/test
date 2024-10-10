import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:task2/bloc/add_bloc.dart';
import 'package:task2/bloc/add_event.dart';
import 'package:task2/bloc/add_state.dart';

class TransactionEntryPage extends StatefulWidget {
  @override
  _TransactionEntryPageState createState() => _TransactionEntryPageState();
}

class _TransactionEntryPageState extends State<TransactionEntryPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Đóng',
            style: TextStyle(fontSize: 18),
          ),
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor:
                    Color.fromARGB(255, 17, 104, 255), // Background color
              ),
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  final formData = _formKey.currentState!.value;
                  context.read<TransactionBloc>().add(SubmitTransaction(
                        transactionTime: formData['transaction_time'],
                        quantity: double.parse(formData['quantity']),
                        pump: formData['pump'],
                        revenue: double.parse(formData['revenue']),
                        unitPrice: double.parse(formData['unit_price']),
                      ));
                }
              },
              child: const Text(
                'Cập nhật',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is TransactionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhập giao dịch',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'transaction_time',
                    inputType: InputType.both,
                    decoration: const InputDecoration(
                      labelText: 'Thời gian',
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
                    format: DateFormat("dd/MM/yyyy HH:mm"),
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn thời gian';
                      }
                      return null; // Hợp lệ
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    name: 'quantity',
                    decoration: const InputDecoration(
                      labelText: 'Số lượng',
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số lượng';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Số lượng phải lớn hơn 0';
                      }
                      return null; // Hợp lệ
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderDropdown<String>(
                    name: 'pump',
                    decoration: const InputDecoration(
                      labelText: 'Trụ',
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
                    items: ['Trụ 1', 'Trụ 2', 'Trụ 3']
                        .map((pump) => DropdownMenuItem(
                              value: pump,
                              child: Text(pump),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn trụ';
                      }
                      return null; // Hợp lệ
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    name: 'revenue',
                    decoration: const InputDecoration(
                      labelText: 'Doanh Thu',
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập doanh thu';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) < 0) {
                        return 'Doanh thu không hợp lệ';
                      }
                      return null; // Hợp lệ
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    name: 'unit_price',
                    decoration: const InputDecoration(
                      labelText: 'Đơn giá',
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập đơn giá';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) < 0) {
                        return 'Đơn giá không hợp lệ';
                      }
                      return null; // Hợp lệ
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
