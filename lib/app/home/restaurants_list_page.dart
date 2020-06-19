import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:firebase_auth_service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_ratings_flutter_firebase/app/home/restaurant_details_page.dart';
import 'package:restaurant_ratings_flutter_firebase/app/home/restaurant_rating_bar.dart';
import 'package:restaurant_ratings_flutter_firebase/constants/strings.dart';
import 'package:restaurant_ratings_flutter_firebase/models/restaurant.dart';
import 'package:restaurant_ratings_flutter_firebase/services/firestore_database.dart';
import 'package:provider/provider.dart';

class RestaurantsListPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
        elevation: 0,
        actions: [
          FlatButton(
            child: Text(
              Strings.logout,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: RestaurantsList(),
    );
  }
}

class RestaurantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<List<Restaurant>>(
      stream: database.restaurants(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final restaurants = snapshot.data ?? [];
        return ListView.separated(
          itemBuilder: (_, index) => RestaurantListTile(
            restaurant: restaurants[index],
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      RestaurantDetailsPage(restaurant: restaurants[index]),
                ),
              );
            },
          ),
          separatorBuilder: (_, index) => Divider(height: 0.5),
          itemCount: restaurants.length,
        );
      },
    );
  }
}

class RestaurantListTile extends StatelessWidget {
  const RestaurantListTile({Key key, @required this.restaurant, this.onPressed})
      : super(key: key);
  final Restaurant restaurant;
  final VoidCallback onPressed;

  String get ratingsString =>
      restaurant.numRatings > 0 ? '${restaurant.numRatings}' : 'No';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(restaurant.name),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RestaurantRatingBar(
                  initialRating:
                      restaurant.numRatings > 0 ? restaurant.avgRating : 0,
                  ignoreGestures: true,
                  itemSize: 24,
                ),
                SizedBox(height: 4),
                Text('$ratingsString ratings'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
