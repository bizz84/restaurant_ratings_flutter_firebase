class FirestorePath {
  static String restaurantUserRating(String restaurantId, String uid) =>
      'restaurants/$restaurantId/ratings/$uid';
  static String restaurants() => 'restaurants';
  static String restaurant(String restaurantId) => 'restaurants/$restaurantId';
}
