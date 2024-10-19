import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User_j extends StatefulWidget {
  const User_j({super.key});

  @override
  State<User_j> createState() => _User_jState();
}

class _User_jState extends State<User_j> {
  var data;
  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserApi() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body.toString());
      });
    } else {
      setState(() {
        data = "Error";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserApi(); // Call API once during initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              print(data);
            },
            child: Text("User Json")),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(),
              image: _image == null
                  ? null
                  : DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
            ),
            child: _image == null
                ? Center(child: Text('No image selected.'))
                : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          Expanded(
            child: data == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext, index) {
                      var user = data[index];
                      return Column(
                        children: [
                          ResuableEmail(
                            address: user['address']['street'].toString(),
                            email: user['email'].toString(),
                            name: user['name'].toString(),
                          ),
                        ],
                      );
                    }),
          ),
        ],
      ),
    );
  }
}

class ResuableEmail extends StatefulWidget {
  String name, email, address;
  ResuableEmail({
    super.key,
    required this.address,
    required this.email,
    required this.name,
  });

  @override
  State<ResuableEmail> createState() => _ResuableEmailState();
}

class _ResuableEmailState extends State<ResuableEmail> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.address),
      subtitle: Text(widget.email),
      trailing: Text(widget.name),
    );
  }
}
