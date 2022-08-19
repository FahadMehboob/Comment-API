import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<CommentModel> commentsList = [];
  Future<List<CommentModel>> getComment() async {
    final responce = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
    var data = jsonDecode(responce.body.toString());
    if (responce.statusCode == 200) {
      for (Map i in data) {
        CommentModel comments =
            CommentModel(name: i['name'], email: i['email'], id: i['id']);
        commentsList.add(comments);
      }
      return commentsList;
    } else {
      return commentsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Comments API"),
      ),
      body: Card(
        child: FutureBuilder(
          future: getComment(),
          builder: (context, AsyncSnapshot<List<CommentModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: commentsList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    color: const Color(0xffebad7f),
                    shadowColor: const Color(0xffe3128c),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ID : ${snapshot.data![index].id}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'NAME : ${snapshot.data![index].name}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'EMAIL : ${snapshot.data![index].email}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CommentModel {
  String name, email;
  int id;
  CommentModel({required this.name, required this.email, required this.id});
}
