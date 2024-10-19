import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RegisterPost extends StatefulWidget {
  const RegisterPost({super.key});

  @override
  State<RegisterPost> createState() => _RegisterPostState();
}

class _RegisterPostState extends State<RegisterPost> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void postData(String email, password) async {
    try {
      Response response = await post(
        Uri.parse('https://reqres.in/api/register'),
        body: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body.toString());
        print(data);
        print("Sucess Fully");
      } else {
        print("Flied");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dumy Home"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  postData(emailController.text.toString(),
                      passwordController.text.toString());
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text("Submit")),
                ),
              )
            ],
          ),
        ));
  }
}
