import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
