import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:menu/data.dart';
import 'package:menu/main.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

String homeScreen = '/';
String restaurantScreen = '/restaurant';

/**
List<Restaurant> getRestaurantList() {
  return [
    Restaurant(
      assetName: 'places/india_thanjavur_market.png',
      title: 'McDonalds',
      description: 'Sample',
      city: 'Sample',
      location: 'Sample',
      images: [
        'https://visitukraine.today/media/blog/previews/7AFRLndDT96gpWHK6ELk6eY7oMTVZ3tpliLBpoBx.jpg',
        'https://foodbay.com/wiki/wp-content/uploads/2020/08/a57c938ba4-2.jpg',
        'https://www.retail.ru/upload/medialibrary/694/3I6A5359_HDR.jpg',
      ],
    ),
    Restaurant(
      assetName: 'places/india_chettinad_silk_maker.png',
      title: 'KFC',
      description: 'Sample',
      city: 'Sample',
      location: 'Sample',
      images: [],
    ),
    Restaurant(
      assetName: 'places/india_tanjore_thanjavur_temple.png',
      title: 'Burger King',
      description: 'Sample',
      city: 'Sample',
      location: 'Sample',
      images: [
        'https://visitukraine.today/media/blog/previews/7AFRLndDT96gpWHK6ELk6eY7oMTVZ3tpliLBpoBx.jpg',
      ],
    ),
  ];
}

//List<RestaurantGroup> getRestaurantGroupList() {
 // return [
 //   RestaurantGroup(title: 'Restaurants', restaurants: getRestaurantList()),
//    RestaurantGroup(title: 'Cafes', restaurants: getRestaurantList()),
 // ];
//}
**/
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

class RestaurantsGroup extends StatelessWidget {
  const RestaurantsGroup({Key? key, required this.group})
      : super(key: key);

  final RestaurantGroup group;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(group.title),
            SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder<List<ParseObject>>(
                future: getRestaurants(group.restaurantIds),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
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
                          padding: EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<String> images = List<String>.from(snapshot.data![index].get("images") ?? []);
                            Restaurant res_temp = Restaurant(
                              title: snapshot.data![index].get("title"),
                              image: images.length > 0 ? images[0] : "assets/loading.gif",
                              images: images,
                            );
                            group.restaurants.add(res_temp);
                            return RestaurantItem(
                              restaurant: res_temp,
                            );
                          },
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantItem extends StatelessWidget {
  const RestaurantItem({Key? key, required this.restaurant})
      : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .colorScheme
                .background,
            borderRadius: const BorderRadius.all(
                Radius.circular(10)
            ),
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .shadowColor,
                blurRadius: 10,
                offset: Offset(3, 3),
              )
            ]
        ),
        child: Stack(
            children: [
              Column(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    height: 120,
                    fit: BoxFit.fill,
                    imageUrl: restaurant.image,
                    placeholder: (context, url) => Image.asset('assets/loading.gif'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                      SizedBox(
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
                    Navigator.pushNamed(
                        context,
                        restaurantScreen,
                        arguments: ScreenArguments(restaurant)
                    );
                  },
                ),
              ),
            ]
        ),
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

  List<RestaurantGroup> groups = [];

  @override
  void initState() {
    //group = getGroupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<ParseObject>>(
            future: getRestaurantsGroups(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
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
                        List<String> restaurantIds = List<String>.from(snapshot.data![index].get("restaurants"));
                        RestaurantGroup groupTemp = RestaurantGroup(
                          title: snapshot.data![index].get("title"),
                          restaurantIds: restaurantIds,
                        );
                        groups.add(groupTemp);
                        return RestaurantsGroup(group: groupTemp);
                      },
                    );
                  };
              }
            }
        ),
      ),
    );
  }
}
