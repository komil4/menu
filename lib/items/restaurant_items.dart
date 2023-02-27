import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../data.dart';
import '../main.dart';

class RestaurantItemBig extends StatefulWidget {
  const RestaurantItemBig({required this.itemData, super.key});

  final ItemData itemData;

  @override
  State<RestaurantItemBig> createState() => _RestaurantItemBigState();
}

class _RestaurantItemBigState extends State<RestaurantItemBig> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: SizedBox(
        width: 360,
        height: 288,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromRGBO(44, 39, 39, 1),
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      width: 360,
                      height: 150,
                      fit: BoxFit.cover,
                      imageUrl: widget.itemData.image,
                      placeholder: (context, url) => Image.asset(
                        'assets/loading.gif',
                        width: 360,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.itemData.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite_outlined,
                                    size: 20,
                                    color: Color.fromRGBO(200, 93, 67, 1),
                                  ),
                                  Text(widget.itemData.rating
                                      .toStringAsFixed(1)),
                                  Text(
                                    '(${widget.itemData.reviewsCount})',
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.currency_ruble_outlined,
                                    size: 15,
                                    color: widget.itemData.costLevel >= 1 ? Colors.white : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.currency_ruble_outlined,
                                    size: 15,
                                    color: widget.itemData.costLevel >= 2 ? Colors.white : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.currency_ruble_outlined,
                                    size: 15,
                                    color: widget.itemData.costLevel >= 3 ? Colors.white : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.currency_ruble_outlined,
                                    size: 15,
                                    color: widget.itemData.costLevel >= 4 ? Colors.white : Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, restaurantScreen,
                      arguments: ScreenArguments(
                          Restaurant(
                              objectId: '', title: '', image: '', images: []),
                          ''));
                },
              ),
              SizedBox(
                width: 360,
                height: 288,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 38,
                      width: 38,
                      child: LikeButton(
                        size: 35,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            isLiked
                                ? Icons.favorite_outlined
                                : Icons.favorite_outline,
                            color: isLiked
                                ? Color.fromRGBO(200, 93, 67, 1)
                                : Color.fromRGBO(44, 39, 39, 1),
                            size: 35,
                          );
                        },
                        onTap: onLikeButtonTapped,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
}

class RestaurantItemMiddle extends StatefulWidget {
  const RestaurantItemMiddle({required this.itemData, super.key});

  final ItemData itemData;

  @override
  State<RestaurantItemMiddle> createState() => _RestaurantItemMiddleState();
}

class _RestaurantItemMiddleState extends State<RestaurantItemMiddle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: SizedBox(
        width: 175,
        height: 288,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromRGBO(44, 39, 39, 1),
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      width: 175,
                      height: 150,
                      fit: BoxFit.cover,
                      imageUrl: widget.itemData.image,
                      placeholder: (context, url) => Image.asset(
                        'assets/loading.gif',
                        width: 175,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: LikeButton(
                          size: 35,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              isLiked
                                  ? Icons.favorite_outlined
                                  : Icons.favorite_outline,
                              color: isLiked
                                  ? Color.fromRGBO(200, 93, 67, 1)
                                  : Color.fromRGBO(44, 39, 39, 1),
                              size: 35,
                            );
                          },
                          onTap: onLikeButtonTapped,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.itemData.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite_outlined,
                                    size: 20,
                                    color: Color.fromRGBO(200, 93, 67, 1),
                                  ),
                                  Text(
                                    widget.itemData.rating.toStringAsFixed(1),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '(${widget.itemData.reviewsCount})',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
}
