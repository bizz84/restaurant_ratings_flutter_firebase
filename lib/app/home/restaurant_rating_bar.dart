import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantRatingBar extends StatelessWidget {
  const RestaurantRatingBar(
      {Key key,
      this.initialRating,
      this.itemSize = 40,
      this.ignoreGestures = false,
      this.onRatingUpdate})
      : super(key: key);
  final double initialRating;
  final bool ignoreGestures;
  final double itemSize;
  final ValueChanged<double> onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: initialRating,
      ignoreGestures: ignoreGestures,
      glow: false,
      allowHalfRating: true,
      itemSize: itemSize,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}
