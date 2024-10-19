import 'package:fflutterapidumy/view/address-model.dart';
import 'package:fflutterapidumy/view/register_post.dart';
import 'package:fflutterapidumy/view/photo.dart';
import 'package:fflutterapidumy/view/user_j.dart';
import 'package:fflutterapidumy/view/users-view.dart';
import 'package:flutter/material.dart';

import 'view/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: User_j(),
    );
  }
}
