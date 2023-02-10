
class Restaurant {
  Restaurant({
    required this.title,
    required this.image,
    required this.images,
  });

  final String title;
  final String image;
  final List<String> images;
}

class RestaurantGroup {
  RestaurantGroup({
    required this.title,
    required this.restaurantIds,
  });

  final String title;
  final List<String> restaurantIds;
  List<Restaurant> restaurants = [];
}

class DishGroup {
  const DishGroup({
    required this.title,
    required this.dishes
  });

  final String title;
  final List<Dish> dishes;
}

class Dish {
  const Dish({
    required this.title,
    required this.image
  });

  final String title;
  final String image;
}
