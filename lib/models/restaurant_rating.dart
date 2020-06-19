import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class RestaurantRating {
  const RestaurantRating({@required this.restaurantId, this.rating});
  final String restaurantId;
  final double rating;

  factory RestaurantRating.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final double rating = data['rating'];
    return RestaurantRating(
      restaurantId: documentId,
      rating: rating,
    );
  }

  // @override
  // int get hashCode => hashValues(restaurantId, rating);

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //   if (runtimeType != other.runtimeType) return false;
  //   final Restaurant otherRestaurant = other;
  //   return id == otherRestaurant.id &&
  //       name == otherRestaurant.name &&
  //       numRatings == otherRestaurant.numRatings &&
  //       avgRating == otherRestaurant.avgRating;
  // }

  // @override
  // String toString() =>
  //     'id: $id, name: $name, numRatings: $numRatings, avgRating: $avgRating';
}
