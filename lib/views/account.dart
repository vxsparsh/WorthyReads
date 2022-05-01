import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worthyreads/views/home.dart';
import 'package:worthyreads/views/my_list.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('My Profile'),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
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
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome\n',
                    style: TextStyle(fontSize: 30),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data!.photoURL.toString(),
                    ),
                    radius: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        snapshot.data!.displayName.toString(),
                        style: const TextStyle(fontSize: 20),
                      )),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _googleSignIn.signOut();
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                    label: const Text('Logout'),
                  )
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login into your Account\n",
                style: TextStyle(fontSize: 30),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final newuser = await _googleSignIn.signIn();
                  final googleauth = await newuser!.authentication;
                  final creds = GoogleAuthProvider.credential(
                    accessToken: googleauth.accessToken,
                    idToken: googleauth.idToken,
                  );
                  await FirebaseAuth.instance.signInWithCredential(creds);
                },
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('Login with Google'),
              ),
            ],
          ));
        },
      ),
    );
  }
}
