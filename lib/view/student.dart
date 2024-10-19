import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model_view/student_model.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  List<ModelId> alldata = [];
  bool isLoading = true;

  Future<List<ModelId>> getDataApi() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        for (Map<String, dynamic> i in data) {
          alldata.add(ModelId.fromJson(i));
        }
        isLoading = false; // Stop loading once data is fetched
      });
    } else {
      throw Exception('Failed to load data');
    }
    return alldata;
  }

  @override
  void initState() {
    super.initState();
    getDataApi(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Data'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
        future: getDataApi(),
        builder: (context, AsyncSnapshot<List<ModelId>> snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: alldata.length, // Specify the number of items
              itemBuilder: (context, index) {
                return ListTile(
                  title: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(alldata[index].title ?? 'No Title'),
                  )),
                  subtitle: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(alldata[index].body ?? 'No Content'),
                  )),
                );
              },
            );
          }
          // Data is loaded

          // Default fallback (if no data)
          return Center(child: Text("No data available"));
        },
      ),
    );
  }
}
