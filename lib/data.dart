
class Restaurant {
  const Restaurant({
    required this.assetName,
    required this.title,
    required this.description,
    required this.city,
    required this.location,
  });

  final String assetName;
  final String title;
  final String description;
  final String city;
  final String location;
}

class Group {
  const Group({
    required this.title,
    required this.restaurants
  });

  final String title;
  final List<Restaurant> restaurants;
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
