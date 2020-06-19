import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class Restaurant {
  const Restaurant(
      {@required this.id,
      @required this.name,
      @required this.numRatings,
      this.avgRating});
  final String id;
  final String name;
  final int numRatings;
  final double avgRating;

  factory Restaurant.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final int numRatings = data['numRatings'] ?? 0;
    final double avgRating = (data['avgRating'] ?? 0).toDouble();
    return Restaurant(
      id: documentId,
      name: name,
      numRatings: numRatings,
      avgRating: avgRating,
    );
  }

  @override
  int get hashCode => hashValues(id, name, numRatings, avgRating);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Restaurant otherRestaurant = other;
    return id == otherRestaurant.id &&
        name == otherRestaurant.name &&
        numRatings == otherRestaurant.numRatings &&
        avgRating == otherRestaurant.avgRating;
  }

  @override
  String toString() =>
      'id: $id, name: $name, numRatings: $numRatings, avgRating: $avgRating';
}
