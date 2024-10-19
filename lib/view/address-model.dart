import 'dart:convert';
import 'package:fflutterapidumy/model_view/addressModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  List<AddressModel> addremodel = [];

  Future<List<AddressModel>> getAddressModel() async {
    try {
      final response =
          await http.get(Uri.parse("https://fakestoreapi.com/products"));
      var data = jsonDecode(response.body.toString());

      addremodel.clear();
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          addremodel.add(AddressModel.fromJson(i));
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return addremodel;
  }

  @override
  void initState() {
    super.initState();
    getAddressModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () async {
            List<AddressModel> addresses = await getAddressModel();
            print(addresses);
          },
          child: const Text("Address Model"),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 208, 133, 133),
      body: FutureBuilder<List<AddressModel>>(
        future: getAddressModel(),
        builder: (context, AsyncSnapshot<List<AddressModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title.toString()),
                );
              },
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
