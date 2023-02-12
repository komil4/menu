
class Restaurant {
  final String title;
  final String image;
  final List<String> images;

  Restaurant({
    required this.title,
    required this.image,
    required this.images,
  });
}

class RestaurantGroup {
  final String title;
  final List<String> restaurantIds;
  List<Restaurant> restaurants = [];

  RestaurantGroup({
    required this.title,
    required this.restaurantIds,
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
