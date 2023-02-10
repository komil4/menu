import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:menu/restaurant_area.dart';
import 'package:menu/restaurant_page.dart';
import 'package:menu/restaurants_area.dart';

import 'data.dart';

String homeScreen = '/';
String restaurantScreen = '/restaurant';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'UeTIruYYIWfOi22mUZZazYuHbypvfFJEvVZx8wSw';
  const keyClientKey = 'b1uUf8FFJuTetVaxcZn03f9nYNNfpLYfHgwhYmks';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final MaterialColor appColor = const MaterialColor(0xff848ddd, <int, Color>{
    50: Color.fromRGBO(132, 141, 221, .1),
    100: Color.fromRGBO(132, 141, 221, .2),
    200: Color.fromRGBO(132, 141, 221, .3),
    300: Color.fromRGBO(132, 141, 221, .4),
    400: Color.fromRGBO(132, 141, 221, .5),
    500: Color.fromRGBO(132, 141, 221, .6),
    600: Color.fromRGBO(132, 141, 221, .7),
    700: Color.fromRGBO(132, 141, 221, .8),
    800: Color.fromRGBO(132, 141, 221, .0),
    900: Color.fromRGBO(132, 141, 221, 1),
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: appColor,
          backgroundColor: const Color.fromRGBO(238, 238, 249, 1),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(248, 247, 253, 1),
        shadowColor: const Color.fromRGBO(214, 216, 229, 1),
      ),
      initialRoute: homeScreen,
      routes: {
        homeScreen: (BuildContext context) => HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == RestaurantPage.routeName) {
          final args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return RestaurantPage(restaurant: args.restaurant);
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
  ScreenArguments(this.restaurant);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget _ListViewBody() {
    switch (_selectedIndex) {
      case 0:
        return RestaurantsArea();
      case 1:
        return RestaurantArea();
    }
    return const Center(
      child: Text('Error page not found!'),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Resto app'),
      ),
      body: _ListViewBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'My list',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
