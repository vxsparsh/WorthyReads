// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worthyreads/views/account.dart';
import 'package:http/http.dart';

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
  final _saved = <Book>[];
  final _suggestions = <Book>[];
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
        child: ListView(
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SavedBooks(saved: _saved),
                  ),
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
      itemBuilder: (context, i) {
        final index = i;
        if (index >= _suggestions.length) {
          _suggestions.addAll(books);
        }

        final alreadySaved = _saved.contains(_suggestions[index]);
        return Card(
          child: ListTile(
            title: Text(
              _suggestions[index].name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _suggestions[index].author,
            ),
            trailing: Icon(
              alreadySaved ? Icons.bookmark_added : Icons.bookmark_add_outlined,
              color: alreadySaved ? Colors.black : null,
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          ),
        );
      },
    );
  }
}

class SavedBooks extends StatelessWidget {
  const SavedBooks({Key? key, required this.saved}) : super(key: key);

  final List<Book> saved;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('My List'),
      ),
      body: saved.isEmpty
          ? const Center(
              child: Text(
                "Nothing Selected",
                style: TextStyle(fontSize: 40),
              ),
            )
          : ListView.builder(
              itemCount: saved.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      saved[index].name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(saved[index].author),
                  ),
                );
              },
            ),
    );
  }
}
