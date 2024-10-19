import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model_view/photos_model.dart';

class PhotosVie extends StatefulWidget {
  const PhotosVie({super.key});

  @override
  State<PhotosVie> createState() => _PhotosVieState();
}

class _PhotosVieState extends State<PhotosVie> {
  List<PhotosModel> bbbbb = [];
  bool color = true;
  Future<List<PhotosModel>> getPhotos() async {
    try {
      var response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      if (response.statusCode == 200) {
        var decod = jsonDecode(response.body.toString());
        for (Map<String, dynamic> i in decod) {
          bbbbb.add(PhotosModel.fromJson(i));
        }
      } else {
        print("Error: Status Code ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching photos: $e");
    }
    return bbbbb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photos"),
      ),
      // backgroundColor: Colors.black,
      body: FutureBuilder(
          future: getPhotos(),
          builder: (context, AsyncSnapshot<List<PhotosModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext, index) {
                    return ListTile(
                      leading: InkWell(
                        onTap: () {
                          print(index);
                          // print(photo.url);
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          child: Image.network(
                            snapshot.data![index].url
                                .toString(), // Hardcoded CORS-safe URL for testing
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                      ),
                      title: Text(snapshot.data![index].title.toString()),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
