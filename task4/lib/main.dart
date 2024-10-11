import 'package:flutter/material.dart';
import 'package:task4/service/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Query Results',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QueryResultScreen(),
    );
  }
}

class QueryResultScreen extends StatefulWidget {
  @override
  _QueryResultScreenState createState() => _QueryResultScreenState();
}

class _QueryResultScreenState extends State<QueryResultScreen> {
  String token = '';
  List<int> results = [];
  bool isPosting = false;
  final apiService =
      ApiService(baseUrl: 'https://test-share.shub.edu.vn/api/intern-test');

  Future<List<int>> processData() async {
    final data = await apiService.fetchData();
    token = data['token']; // Save the token for the POST request

    final List<int> arr = List<int>.from(data['data']);
    final List<dynamic> queries = data['query'];
    final int n = arr.length;

    // Compute prefix sums
    List<int> sum1 = List.filled(n, 0);
    List<int> sumEven = List.filled(n, 0);
    List<int> sumOdd = List.filled(n, 0);

    for (int i = 0; i < n; i++) {
      sum1[i] = arr[i] + (i > 0 ? sum1[i - 1] : 0);
      if (i % 2 == 0) {
        sumEven[i] = arr[i] + (i > 0 ? sumEven[i - 1] : 0);
        sumOdd[i] = i > 0 ? sumOdd[i - 1] : 0;
      } else {
        sumOdd[i] = arr[i] + (i > 0 ? sumOdd[i - 1] : 0);
        sumEven[i] = i > 0 ? sumEven[i - 1] : 0;
      }
    }

    // Process queries
    results = [];
    for (var query in queries) {
      int type = int.parse(query['type']);
      List<int> range = List<int>.from(query['range']);
      int left = range[0] - 1;
      int right = range[1] - 1;

      if (type == 1) {
        int result = sum1[right] - (left > 0 ? sum1[left - 1] : 0);
        results.add(result);
      } else if (type == 2) {
        int sumEvenRange = sumEven[right] - (left > 0 ? sumEven[left - 1] : 0);
        int sumOddRange = sumOdd[right] - (left > 0 ? sumOdd[left - 1] : 0);
        results.add(sumEvenRange - sumOddRange);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query Results'),
      ),
      body: Center(
        child: FutureBuilder<List<int>>(
          future: processData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final results = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Result ${index + 1}: ${results[index]}'),
                        );
                      },
                    ),
                  ),
                  isPosting
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isPosting = true;
                            });
                            try {
                              await apiService.postData(token, results);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Results successfully posted')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to post')));
                            }
                            setState(() {
                              isPosting = false;
                            });
                          },
                          child: Text('Post Results'),
                        ),
                ],
              );
            } else {
              return Text('No results found.');
            }
          },
        ),
      ),
    );
  }
}
