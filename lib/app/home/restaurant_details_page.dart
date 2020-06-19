import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_ratings_flutter_firebase/app/home/restaurant_rating_bar.dart';
import 'package:restaurant_ratings_flutter_firebase/constants/strings.dart';
import 'package:restaurant_ratings_flutter_firebase/models/restaurant.dart';
import 'package:restaurant_ratings_flutter_firebase/services/firestore_database.dart';
import 'package:provider/provider.dart';

class RestaurantDetailsPage extends StatelessWidget {
  const RestaurantDetailsPage({Key key, this.restaurant}) : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: Column(
        children: [
          Spacer(flex: 1),
          RestaurantRatingDisplay(restaurant: restaurant),
          SizedBox(height: 64),
          RestaurantRatingPrompt(restaurant: restaurant),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class RestaurantRatingDisplay extends StatelessWidget {
  const RestaurantRatingDisplay({Key key, this.restaurant}) : super(key: key);
  final Restaurant restaurant;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<Restaurant>(
      stream: database.restaurant(restaurant.id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final restaurant = snapshot.data;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Average rating'),
              RestaurantRatingBar(
                initialRating: restaurant?.avgRating ?? 0,
                ignoreGestures: true,
                itemSize: 24.0,
              ),
              if (restaurant != null)
                Text('from ${restaurant.numRatings} ratings'),
            ],
          ),
        );
      },
    );
  }
}

class RestaurantRatingPrompt extends StatelessWidget {
  const RestaurantRatingPrompt({Key key, this.restaurant}) : super(key: key);
  final Restaurant restaurant;

  Future<void> _submitRating(BuildContext context, {double rating}) async {
    try {
      final bool didConfirmSubmit = await showAlertDialog(
            context: context,
            title: 'Submit Rating',
            content: 'Do you want to submit a rating of $rating?',
            cancelActionText: Strings.cancel,
            defaultActionText: 'Submit',
          ) ??
          false;
      if (didConfirmSubmit) {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        await database.submitUserRating(restaurant: restaurant, rating: rating);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<double>(
      stream: database.restaurantUserRating(restaurant.id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final rating = snapshot.data;
        // user never rated this before
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(rating == null ? 'Tap to rate' : 'You rated this restaurant:',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8),
            RestaurantRatingBar(
              initialRating: rating ?? 0,
              ignoreGestures: false,
              itemSize: 40,
              onRatingUpdate: (newRating) => _submitRating(
                context,
                rating: newRating,
              ),
            )
          ],
        );
      },
    );
  }
}
