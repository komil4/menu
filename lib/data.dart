
class Restaurant {
  final String objectId;
  final String title;
  final String image;
  final List<String> images;

  Restaurant({
    required this.objectId,
    required this.title,
    required this.image,
    required this.images,
  });
}

class RestaurantGroup {
  final String title;
  final itemsSize;
  final List<String> restaurantIds;
  List<Restaurant> restaurants = [];

  RestaurantGroup({
    required this.title,
    required this.restaurantIds,
    required this.itemsSize,
  });
}

class DishGroup {
  final String title;
  final List<Dish> dishes;

  const DishGroup({
    required this.title,
    required this.dishes
  });
}

class Dish {
  final String title;
  final String image;

  const Dish({
    required this.title,
    required this.image
  });
}

class ItemData {
  final String className;
  final String objectId;
  final String title;
  final String description;
  final String image;
  final double cost;
  final double rating;
  final int reviewsCount;
  final int costLevel;
  bool isFavorite = false;

  ItemData({
    required this.className,
    required this.objectId,
    required this.title,
    required this.description,
    required this.image,
    required this.cost,
    required this.rating,
    required this.reviewsCount,
    required this.isFavorite,
    required this.costLevel,
  });
}