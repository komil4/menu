import 'dart:convert';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:menu/data.dart';
import 'package:menu/main.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'groups/restaurant_groups.dart';

String homeScreen = '/';
String restaurantScreen = '/restaurant';

Future<List<ParseObject>> getRestaurantsGroups() async {
  QueryBuilder<ParseObject> queryRestaurantGroup =
      QueryBuilder<ParseObject>(ParseObject('RestaurantGroup'));
  final ParseResponse apiResponse = await queryRestaurantGroup.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<List<ParseObject>> getRestaurants(restaurantIds) async {
  QueryBuilder<ParseObject> queryRestaurants =
      QueryBuilder<ParseObject>(ParseObject('Restaurant'));
  queryRestaurants.whereContainedIn('objectId', restaurantIds);
  final ParseResponse apiResponse = await queryRestaurants.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

class RestaurantItem extends StatelessWidget {
  const RestaurantItem({Key? key, required this.restaurant}) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Container(
        width: 250,
        height: 180,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(39, 39, 39, 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(children: [
          Column(children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: 120,
                fit: BoxFit.cover,
                imageUrl: restaurant.image,
                placeholder: (context, url) => Image.asset(
                  'assets/loading.gif',
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Text(restaurant.title),
                ],
              ),
            ),
          ]),
          Material(
            color: Colors.white.withOpacity(0),
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, restaurantScreen,
                    arguments: ScreenArguments(restaurant, ''));
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class RestaurantsArea extends StatefulWidget {
  const RestaurantsArea({Key? key}) : super(key: key);

  @override
  _RestaurantsAreaState createState() => _RestaurantsAreaState();
}

class _RestaurantsAreaState extends State<RestaurantsArea> {
  String searchValue = '';
  TextEditingController textController = TextEditingController();
  final List<String> _countries = [
    'Afeganistan',
    'Albania',
    'Algeria',
    'Australia',
    'Brazil',
    'German',
    'Madagascar',
    'Mozambique',
    'Portugal',
    'Zambia'
  ];
  late TextEditingController controller;
  late List<String> countries = _countries;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 65),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(37, 37, 37, 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(0, 5))
                  ]),
              alignment: Alignment.center,
              child: AnimationSearchBar(
                  isBackButtonVisible: false,
                  centerTitle: 'App Title',
                  onChanged: (text) {
                    countries = _countries
                        .where(
                            (e) => e.toLowerCase().contains(text.toLowerCase()))
                        .toList();
                    setState(() {});
                  },
                  searchTextEditingController: textController,
                  horizontalPadding: 5),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(children: [
            FutureBuilder<List<ParseObject>>(
                future: getRestaurantsGroups(),
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
