// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worthyreads/views/account.dart';
import 'package:http/http.dart';
import 'package:worthyreads/views/my_list.dart';

//connecting to the endpoint
class HttpService {
  final String booksURL = "https://book-api-worthyreads.herokuapp.com/books";

  Future<List<Book>> getbooks() async {
    Response res = await get(Uri.parse(booksURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Book> books = body
          .map(
            (dynamic item) => Book.fromJson(item),
          )
          .toList();

      return books;
    } else {
      throw "Unable to retrieve books.";
    }
  }
}

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));
String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book({
    required this.name,
    required this.author,
  });
  String name;
  String author;
  factory Book.fromJson(Map<String, dynamic> json) => Book(
        name: json["name"],
        author: json["author"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "author": author,
      };
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Discover',
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the Book can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.bookOpen,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Worthy Reads',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.compass,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Discover',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.list,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'My List',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyList()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.userAstronaut,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'My Profile',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _buildBody(context),
    );
  }

  FutureBuilder<List<Book>> _buildBody(BuildContext context) {
    final HttpService httpService = HttpService();
    return FutureBuilder<List<Book>>(
      future: httpService.getbooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Book>? books = snapshot.data;
          return _buildbooks(context, books!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildbooks(BuildContext context, List<Book> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              (books[index].name),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(books[index].author),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_add_outlined)),
          ),
        );
      },
    );
  }
}
