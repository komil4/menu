import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'globals.dart' as globals;

class UserArea extends StatefulWidget {
  const UserArea({Key? key}) : super(key: key);

  @override
  State<UserArea> createState() => _UserAreaState();
}

class _UserAreaState extends State<UserArea> {
  final signInScreen = '/signIn';
  final homeScreen = '';
  final secureStorage = const FlutterSecureStorage();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(globals.avatar),
                  radius: 100,
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  globals.userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(globals.userEmail),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
                    ),
                    onPressed: () {
                      doUserSignOut();
                      Navigator.popAndPushNamed(context, signInScreen);
                      },
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Sign out',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserSignOut() async {
    await secureStorage.write(key: 'KEY_USERNAME', value: '');
    await secureStorage.write(key: 'KEY_PASSWORD', value: '');
    globals.userEmail = '';
    globals.userEmail = '';
    globals.userId = '';
    globals.sessionToken = '';
    globals.avatar = '';
    globals.isLoggedIn = false;
  }
}
