import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:menu/data.dart';
import 'package:menu/main.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'additional/favourite_btn.dart';
import 'groups/restaurant_groups.dart';
import 'items/item_big.dart';
import 'items/restaurant_items.dart';

String homeScreen = '/';
String restaurantScreen = '/restaurant';

Future<List<ParseObject>> getFavourites() async {
  QueryBuilder<ParseObject> queryRestaurantGroup =
  QueryBuilder<ParseObject>(ParseObject('RestaurantGroup'));
  final ParseResponse apiResponse = await queryRestaurantGroup.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

class FavouritesArea extends StatefulWidget {
  const FavouritesArea({Key? key}) : super(key: key);

  @override
  _FavouritesAreaState createState() => _FavouritesAreaState();
}

class _FavouritesAreaState extends State<FavouritesArea> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(children: [
            FutureBuilder<List<ParseObject>>(
                future: getFavourites(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error get data!"),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Data..."),
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<String> restaurantIds = List<String>.from(
                                snapshot.data![index].get("restaurants"));
                            RestaurantGroup groupTemp = RestaurantGroup(
                              title: snapshot.data![index].get("title"),
                              itemsSize: snapshot.data![index].get("itemsSize"),
                              restaurantIds: restaurantIds,
                            );
                            return RestaurantsGroup(group: groupTemp);
                          },
                        );
                      }
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
