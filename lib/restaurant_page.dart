import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:menu/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Future<List<ParseObject>> getDishGroups(restaurantId) async {
  QueryBuilder<ParseObject> queryDishGroups =
      QueryBuilder<ParseObject>(ParseObject('DishGroup'))
        ..whereEqualTo('restaurantId', restaurantId);
  final ParseResponse apiResponse = await queryDishGroups.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<List<ParseObject>> getDishes(restaurantId, groupId) async {
  QueryBuilder<ParseObject> queryDishes =
      QueryBuilder<ParseObject>(ParseObject('Dish'))
        ..whereEqualTo('restaurantId', restaurantId)
        ..whereContains('dishGroups', groupId)
        ..whereEqualTo('inStopList', false);
  final ParseResponse apiResponse = await queryDishes.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

class MenuItem extends StatelessWidget {
  final Dish _dish;

  const MenuItem({Key? key, required Dish dish})
      : _dish = dish,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 240,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 20,
                offset: Offset(10, 10),
              )
            ]),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: FadeInImage.assetNetwork(
              width: MediaQuery.of(context).size.width,
              height: 240,
              fit: BoxFit.cover,
              image: _dish.image,
              placeholder: 'assets/loading.gif',
            ),
          ),
          Positioned(
            top: 190,
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Column(children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        height: 40,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 3,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Text(_dish.title),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
          Material(
            color: Colors.white.withOpacity(0),
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              onTap: () {
                //Navigator.pushNamed(context, restaurantScreen);
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class RestaurantPage extends StatefulWidget {
  static const routeName = '/restaurant';
  final Restaurant restaurant;
  final String tableId;

  const RestaurantPage(
      {Key? key, required this.restaurant, required this.tableId})
      : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<DishGroup> menu = [
    DishGroup(title: 'Salads', dishes: [
      Dish(
        title: 'Salad 1',
        image:
            'https://www.allrecipes.com/thmb/SkWzUVjyC9DRoefa4t7tjkPS0no=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/14373-GreekSaladi-mfs-4X3-0354-e8388819cafa4bae843ea433258aa03d.jpg',
      ),
      Dish(
        title: 'Salad 2',
        image:
            'https://www.thespruceeats.com/thmb/jSsI2w8FkyTDrJhQkYJ5d0HS2uE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/green-salad-recipe-ensalada-verde-3083556-hero-01-256ac7f4162b45e5a1f82a5234a0708c.jpg',
      ),
      Dish(
        title: 'Salad 3',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhZ0X8bh0blFMBhz2H2Zd9htDlsA3LX-nhhA&usqp=CAU',
      ),
      Dish(
        title: 'Salad 4',
        image:
            'https://img.taste.com.au/OcShKoFw/taste/2017/10/10-minute-summer-gnocchi-and-prawn-salad_1980x1320-131690-1.jpg',
      ),
    ]),
    DishGroup(title: 'Soups', dishes: [
      Dish(
          title: 'Soup 1',
          image:
              'https://hips.hearstapps.com/hmg-prod/images/best-soup-recipes-1660232265.jpeg'),
      Dish(
          title: 'Soup 2',
          image:
              'https://img.taste.com.au/JvrmexiB/taste/2016/11/speedy-tuscan-white-bean-soup-111016-1.jpg'),
      Dish(
          title: 'Soup 3',
          image:
              'https://www.thespruceeats.com/thmb/XO_fVSfQdP77TTpR_hw8rXT4yI8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/oxtail-soup-recipe-1809192-hero-01-346f226cecca4eec8a89a87b4e7b7bb5.jpg'),
      Dish(
          title: 'Soup 4',
          image:
              'https://static01.nyt.com/images/2017/01/11/dining/11SOUP1/11SOUP1-superJumbo.jpg'),
    ]),
    DishGroup(title: 'Main course', dishes: [
      Dish(
          title: 'Meat',
          image:
              'data:image/jpeg;base64,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'),
      Dish(
          title: 'Fish',
          image:
              'https://imagesvc.meredithcorp.io/v3/mm/image?q=60&c=sc&poi=%5B448%2C331%5D&w=896&h=448&url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F19%2F2017%2F04%2F18%2Fwholeroastedredsnapper.jpg'),
      Dish(
          title: 'Burger',
          image:
              'https://www.shutterstock.com/image-photo/berger-photo-wallpaper-260nw-2116271666.jpg'),
      Dish(
          title: 'Pasta',
          image:
              'https://realfood.tesco.com/media/images/1400x919-tomato-pasta-6a5a3c8e-f111-490d-805c-9b62fbec8691-0-1400x919.jpg'),
    ]),
    DishGroup(title: 'Dessert', dishes: [
      Dish(
          title: 'Meat',
          image:
              'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/dessert-main-image-molten-cake-0fbd4f2.jpg'),
      Dish(
          title: 'Fish',
          image:
              'https://storcpdkenticomedia.blob.core.windows.net/media/recipemanagementsystem/media/recipe-media-files/recipes/retail/x17/17244-caramel-topped-ice-cream-dessert-760x580.jpg?ext=.jpg'),
      Dish(
          title: 'Burger',
          image:
              'https://realfood.tesco.com/media/images/RFO-1400x919-classic-chocolate-mousse-69ef9c9c-5bfb-4750-80e1-31aafbd80821-0-1400x919.jpg'),
      Dish(
          title: 'Pasta',
          image:
              'data:image/jpeg;base64,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'),
    ]),
  ];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.restaurant.title),
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.restaurant.images.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 290,
                        child: ClipRRect(
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            image: widget.restaurant.images[itemIndex],
                            placeholder: 'assets/loading.gif',
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 2.0,
                      initialPage: 0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Additional info'),
                  Text('Restaurant photos'),
                  Text('Additional info'),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -appBar.preferredSize.height,
              child: FutureBuilder(
                  future: getDishGroups(widget.restaurant.objectId),
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
                          return Column(
                            children: [
                              SizedBox(
                                child: DefaultTabController(
                                  length: snapshot.data!.length,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height -appBar.preferredSize.height,
                                    child: Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                          child: TabBar(
                                            isScrollable: true,
                                            tabs: snapshot.data!
                                                  .map((e) =>
                                                      Tab(text: e.get('title')))
                                                  .toList()),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height -appBar.preferredSize.height - 60,
                                            child: TabBarView(
                                            children: snapshot.data!
                                                .map(
                                                  (e) => FutureBuilder(
                                                        future: getDishes(
                                                            widget.restaurant
                                                                .objectId,
                                                            e.get('objectId')),
                                                        builder: (context,
                                                            itemSnapshot) {
                                                          switch (itemSnapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .none:
                                                            case ConnectionState
                                                                .waiting:
                                                              return Center(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              );
                                                            default:
                                                              if (itemSnapshot
                                                                  .hasError) {
                                                                return const Center(
                                                                  child: Text(
                                                                      "Error get data!"),
                                                                );
                                                              }
                                                              if (!itemSnapshot
                                                                  .hasData) {
                                                                return const Center(
                                                                  child: Text(
                                                                      "No Data..."),
                                                                );
                                                              } else {
                                                                return ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          ClampingScrollPhysics(),
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount: itemSnapshot
                                                                          .data!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int itemIndex) {
                                                                        return SizedBox(
                                                                          height:
                                                                              280,
                                                                          child:
                                                                              MenuItem(
                                                                            dish:
                                                                                Dish(title: itemSnapshot.data![itemIndex].get('title'), image: itemSnapshot.data![itemIndex].get('images')![0]),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                              }
                                                          }
                                                        }),

                                                )
                                                .toList(),
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
