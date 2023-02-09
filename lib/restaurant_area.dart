import 'package:flutter/material.dart';

class RestaurantArea extends StatefulWidget {
  const RestaurantArea({Key? key}) : super(key: key);

  @override
  _RestaurantAreaState createState() => _RestaurantAreaState();
}

class _RestaurantAreaState extends State<RestaurantArea> {

  List restaurantsList = [];

  @override
  void initState() {
    restaurantsList.addAll(['First retauant', 'Second resaurant']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: restaurantsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(restaurantsList[index]),
                  child: Card(
                    child: ListTile(title: Text(restaurantsList[index])),
                  )
              );
            })
    );
  }
}
