import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model_view/users_model.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  List<UsersModel> usermodel = [];
  Future<List<UsersModel>> getUserData() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      var data = jsonDecode(response.body.toString());
      print("data data fetched ${data}");
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          print(i['name']);
          usermodel.add(UsersModel.fromJson(i));
        }
      } else {
        print("Error Here ${response.statusCode}");
      }
    } catch (e) {
      Text("Error Here${e}");
    }
    return usermodel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              print(getUserData());
            },
            child: Text("Users")),
      ),
      body: FutureBuilder(
          future: getUserData(),
          builder: (context, AsyncSnapshot<List<UsersModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext, index) {
                    var user = snapshot.data![index];
                    return Column(
                      children: [
                        Reasuable(
                          company: '${snapshot.data![index].company!.bs}',
                          address:
                              '${snapshot.data![index].address!.city.toString()}',
                          email: '${user.email.toString()}',
                          name: '${user.name}',
                        ),
                        Reasuable(
                          company: '',
                          address:
                              '${snapshot.data![index].address!.geo.toString()}',
                          email: '${user.email.toString()}',
                          name: '${user.name}',
                        ),
                      ],
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class Reasuable extends StatelessWidget {
  String name, email, address, company;
  Reasuable(
      {super.key,
      required this.address,
      required this.email,
      required this.company,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: Text(company),
      subtitle: Text(address),
      trailing: Text(email),
    );
  }
}
