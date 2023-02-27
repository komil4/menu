import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'globals.dart' as globals;

class SignUpPage extends StatefulWidget {
  static const routeName = '/signUp';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final signInScreen = '/signIn';
  final homeScreen = '/';
  final secureStorage = const FlutterSecureStorage();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
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
              height: 50,
            ),
            const Text('Create Account'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: controllerUsername,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'E-mail'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: TextField(
                controller: controllerPassword,
                obscureText: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                controller: controllerConfirmPassword,
                obscureText: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(hintText: 'Confirm password'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  doUserRegistration();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Register'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: const [
                  Text('By continuing you are indicating that you accept'),
                  SizedBox(
                    height: 3,
                  ),
                  Text('out Terms of Use and our Privacy Policy'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                Divider(
                  thickness: 3,
                ),
                Text('or'),
                Divider(
                  thickness: 3,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {},
                    child: const ImageIcon(AssetImage('assets/google_logo.png'))),
                ElevatedButton(
                    onPressed: () {},
                    child: const ImageIcon(AssetImage('assets/google_logo.png'))),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                        text: 'Sign in',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () { Navigator.popAndPushNamed(context, signInScreen); }
                    ),
                  ]
                )
            )
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

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    final confirmPassword = controllerConfirmPassword.text.trim();

    if (password.compareTo(confirmPassword) != 0) {
      showError("Don't confirm password. Check you password!");
      return;
    }

    final user = ParseUser.createUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      globals.isLoggedIn = true;
      globals.userName = username;
      globals.userId = response.result.objectId;
      globals.sessionToken = response.result.sessionToken;

      await globals.userData();

      await secureStorage.write(key: 'KEY_USERNAME', value: username);
      await secureStorage.write(key: 'KEY_PASSWORD', value: password);

      if (globals.isLoggedIn) {
        await Navigator.popAndPushNamed(context, homeScreen);
      }
    } else {
      showError(response.error!.message);
    }
  }
}
