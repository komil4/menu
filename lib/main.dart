import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:menu/user_area.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'favourites_area.dart';
import 'signup.dart';
import 'signin.dart';
import 'globals.dart' as globals;
import 'restaurant_area.dart';
import 'restaurant_page.dart';
import 'restaurants_area.dart';
import 'qr_code_scanner_area.dart';
import 'data.dart';

String firstScreen = '/signUp';
String homeScreen = '/';
String restaurantScreen = '/restaurant';
String signUpScreen= '/signUp';
String signInScreen= '/signIn';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'UeTIruYYIWfOi22mUZZazYuHbypvfFJEvVZx8wSw';
  const keyClientKey = 'b1uUf8FFJuTetVaxcZn03f9nYNNfpLYfHgwhYmks';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  const secureStorage = FlutterSecureStorage();

  var username = await secureStorage.read(key: 'KEY_USERNAME') ?? '';
  var password = await secureStorage.read(key: 'KEY_PASSWORD') ?? '';

  if (username.isNotEmpty && password.isNotEmpty ) {
    var user = ParseUser(username, password, null);
    var response = await user.login();
    if (response.success) {
      globals.isLoggedIn = true;
      globals.userName = username;
      globals.userId = response.result.objectId;
      globals.sessionToken = response.result.sessionToken;

      await globals.userData();
      firstScreen = homeScreen;
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MaterialColor appColor = const MaterialColor(0xffd5c340, <int, Color>{
    50: Color.fromRGBO(213, 195, 64, .1),
    100: Color.fromRGBO(213, 195, 64, .2),
    200: Color.fromRGBO(213, 195, 64, .3),
    300: Color.fromRGBO(213, 195, 64, .4),
    400: Color.fromRGBO(213, 195, 64, .5),
    500: Color.fromRGBO(213, 195, 64, .6),
    600: Color.fromRGBO(213, 195, 64, .7),
    700: Color.fromRGBO(213, 195, 64, .8),
    800: Color.fromRGBO(213, 195, 64, .9),
    900: Color.fromRGBO(213, 195, 64, 1),
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: appColor,
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(19, 19, 19, 1),
        shadowColor: const Color.fromRGBO(214, 216, 229, 1),
        textTheme: Theme.of(context).textTheme.apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
          fontFamily: 'Roboto',
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          floatingLabelStyle: TextStyle(color: Colors.white),
          helperStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Color.fromRGBO(37, 37, 37, 1),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0),
            borderRadius: BorderRadius.all(Radius.circular(15),),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(95, 194, 125, 1),
            foregroundColor: Colors.white,
          ),
        )
      ),
      initialRoute: firstScreen,
      routes: {
        homeScreen: (BuildContext context) => HomePage(),
        signInScreen: (BuildContext context) => SignInPage(),
        signUpScreen: (BuildContext context) => SignUpPage(),

      },
      onGenerateRoute: (settings) {
        if (settings.name == RestaurantPage.routeName) {
          final args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return RestaurantPage(restaurant: args.restaurant, tableId: '',);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      //home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ScreenArguments {
  final Restaurant restaurant;
  final String tableId;
  ScreenArguments(this.restaurant, this.tableId);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          Center(child: Text('Error page not found!')),
          const RestaurantsArea(),
          QrCodeArea(active: _selectedIndex == 2,),
          const FavouritesArea(),
          const UserArea(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //useLegacyColorScheme: false,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Color.fromRGBO(88, 88, 88, 1),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Color.fromRGBO(37, 37, 37, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Recommended',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          }
        );
        }
      ),
    );
  }
}
