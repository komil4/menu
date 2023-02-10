import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menu/data.dart';
import 'package:menu/main.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

String homeScreen = '/';
String restaurantScreen = '/restaurant';

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

List<RestaurantGroup> getRestaurantGroupList() {
  return [
    RestaurantGroup(title: 'Restaurants', restaurants: getRestaurantList()),
    RestaurantGroup(title: 'Cafes', restaurants: getRestaurantList()),
  ];
}

Future<List<ParseObject>> getRestaurantsGroups() async {
  QueryBuilder<ParseObject> queryTodo =
    QueryBuilder<ParseObject>(ParseObject('RestaurantGroup'));
  final ParseResponse apiResponse = await queryTodo.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<List<ParseObject>> getRestaurants() async {
  QueryBuilder<ParseObject> queryTodo =
  QueryBuilder<ParseObject>(ParseObject('Restaurant'));
  final ParseResponse apiResponse = await queryTodo.query();

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
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(group.title),
            SizedBox(height: 10,),
            Expanded(
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
                          padding: EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RestaurantItem(
                                restaurant: group.restaurants[index]);
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
        height: 150,
        decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(
                    Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: Offset(3, 3),
                  )
                ]
              ),
        child: Stack(
            children: [
              Column(children: [
                const ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image(
                      fit: BoxFit.fill,
                      width: 200,
                      height: 100,
                      image: NetworkImage(
                          'https://cdn.vox-cdn.com/thumbor/5d_RtADj8ncnVqh-afV3mU-XQv0=/0x0:1600x1067/1200x900/filters:focal(672x406:928x662)/cdn.vox-cdn.com/uploads/chorus_image/image/57698831/51951042270_78ea1e8590_h.7.jpg')),
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

  List<RestaurantGroup> group =[];

  @override
  void initState() {
    //group = getGroupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea (
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
    itemCount: group.length,
    itemBuilder: (BuildContext context, int index) {
    return RestaurantsGroup(group: group[index],);
    }
    );
    }
      ),
    ),
        );
  }
}
