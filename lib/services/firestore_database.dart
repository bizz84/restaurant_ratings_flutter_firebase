import 'dart:async';

import 'package:firestore_service/firestore_service.dart';
import 'package:restaurant_ratings_flutter_firebase/models/restaurant.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_ratings_flutter_firebase/services/firestore_path.dart';

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> submitUserRating({Restaurant restaurant, double rating}) =>
      _service.setData(
        path: FirestorePath.restaurantUserRating(restaurant.id, uid),
        data: {'rating': rating},
      );

  Stream<List<Restaurant>> restaurants() => _service.collectionStream(
        path: FirestorePath.restaurants(),
        builder: (data, documentId) => Restaurant.fromMap(data, documentId),
      );

  Stream<Restaurant> restaurant(String restaurantId) => _service.documentStream(
        path: FirestorePath.restaurant(restaurantId),
        builder: (data, documentId) => Restaurant.fromMap(data, documentId),
      );

  Stream<double> restaurantUserRating(String restaurantId) =>
      _service.documentStream(
        path: FirestorePath.restaurantUserRating(restaurantId, uid),
        builder: (data, _) => data != null ? data['rating'] : null,
      );
}
