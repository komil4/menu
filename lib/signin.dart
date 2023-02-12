import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'globals.dart' as globals;

class SignInPage extends StatefulWidget {
  static const routeName = '/signIn';

  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final signUpScreen = '/signUp';
  final homeScreen = '';
  final secureStorage = FlutterSecureStorage();
  final controllerPassword = TextEditingController();
  final controllerUsername = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text('Create Account'),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: TextField(
                    controller: controllerUsername,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(hintText: 'Username'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: TextField(
                    controller: controllerPassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () => doUserLogin(),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Sign in'),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () => Navigator.popAndPushNamed(context, signUpScreen),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Back to register'),
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
          title: const Text("Authentication error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
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

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      globals.isLoggedIn = true;
      globals.userName = username;
      //globals.userEmail = response.result.email;
      globals.userId = response.result.objectId;
      globals.sessionToken = response.result.sessionToken;

      await secureStorage.write(key: 'KEY_USERNAME', value: username);
      await secureStorage.write(key: 'KEY_PASSWORD', value: password);

      Navigator.popAndPushNamed(context, homeScreen);
    } else {
      showError(response.error!.message);
    }
  }

}


