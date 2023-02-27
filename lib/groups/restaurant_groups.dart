import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../data.dart';
import '../favourites_area.dart';
import '../items/restaurant_items.dart';

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
  final RestaurantGroup group;

  const RestaurantsGroup({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 291,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            const SizedBox(
              height: 7,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  group.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
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
                          padding: const EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<String> images = List<String>.from(
                                snapshot.data![index].get("images") ?? []);
                            ItemData itemData = ItemData(
                              className: 'Restaurant',
                              objectId: snapshot.data![index].get("objectId"),
                              title: snapshot.data![index].get("title"),
                              description: '',
                              image: images.isNotEmpty
                                  ? images[0]
                                  : "assets/loading.gif",
                              cost: 320.50,
                              rating: 4.3,
                              reviewsCount: 42,
                              costLevel: 3,
                              isFavorite: false,
                            );
                            return group.itemsSize == 1
                                ? RestaurantItemBig(
                              itemData: itemData,
                            )
                                : RestaurantItemMiddle(
                              itemData: itemData,
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
