import 'package:firebase_analytics/firebase_analytics.dart';

class MockFirebaseAnalytics implements FirebaseAnalytics {
  @override
  FirebaseAnalyticsAndroid get android => throw UnimplementedError();

  @override
  Future<void> logAddPaymentInfo() {
    throw UnimplementedError();
  }

  @override
  Future<void> logAddToCart(
      {String itemId,
      String itemName,
      String itemCategory,
      int quantity,
      double price,
      double value,
      String currency,
      String origin,
      String itemLocationId,
      String destination,
      String startDate,
      String endDate}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logAddToWishlist(
      {String itemId,
      String itemName,
      String itemCategory,
      int quantity,
      double price,
      double value,
      String currency,
      String itemLocationId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logAppOpen() async {}

  @override
  Future<void> logBeginCheckout(
      {double value,
      String currency,
      String transactionId,
      int numberOfNights,
      int numberOfRooms,
      int numberOfPassengers,
      String origin,
      String destination,
      String startDate,
      String endDate,
      String travelClass}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logCampaignDetails(
      {String source,
      String medium,
      String campaign,
      String term,
      String content,
      String aclid,
      String cp1}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logEarnVirtualCurrency({String virtualCurrencyName, num value}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logEcommercePurchase(
      {String currency,
      double value,
      String transactionId,
      double tax,
      double shipping,
      String coupon,
      String location,
      int numberOfNights,
      int numberOfRooms,
      int numberOfPassengers,
      String origin,
      String destination,
      String startDate,
      String endDate,
      String travelClass}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logEvent({String name, Map<String, dynamic> parameters}) async {}

  @override
  Future<void> logGenerateLead({String currency, double value}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logJoinGroup({String groupId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logLevelEnd({String levelName, int success}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logLevelStart({String levelName}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logLevelUp({int level, String character}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logLogin({String loginMethod}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logPostScore({int score, int level, String character}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logPresentOffer(
      {String itemId,
      String itemName,
      String itemCategory,
      int quantity,
      double price,
      double value,
      String currency,
      String itemLocationId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logPurchaseRefund(
      {String currency, double value, String transactionId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logRemoveFromCart(
      {String itemId,
      String itemName,
      String itemCategory,
      int quantity,
      double price,
      double value,
      String currency,
      String origin,
      String itemLocationId,
      String destination,
      String startDate,
      String endDate}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logSearch(
      {String searchTerm,
      int numberOfNights,
      int numberOfRooms,
      int numberOfPassengers,
      String origin,
      String destination,
      String startDate,
      String endDate,
      String travelClass}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logSelectContent({String contentType, String itemId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logSetCheckoutOption({int checkoutStep, String checkoutOption}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logShare({String contentType, String itemId, String method}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logSignUp({String signUpMethod}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logSpendVirtualCurrency(
      {String itemName, String virtualCurrencyName, num value}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logTutorialBegin() {
    throw UnimplementedError();
  }

  @override
  Future<void> logTutorialComplete() {
    throw UnimplementedError();
  }

  @override
  Future<void> logUnlockAchievement({String id}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logViewItem(
      {String itemId,
      String itemName,
      String itemCategory,
      String itemLocationId,
      double price,
      int quantity,
      String currency,
      double value,
      String flightNumber,
      int numberOfPassengers,
      int numberOfNights,
      int numberOfRooms,
      String origin,
      String destination,
      String startDate,
      String endDate,
      String searchTerm,
      String travelClass}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logViewItemList({String itemCategory}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logViewSearchResults({String searchTerm}) {
    throw UnimplementedError();
  }

  @override
  Future<void> resetAnalyticsData() async {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setCurrentScreen(
      {String screenName, String screenClassOverride = 'Flutter'}) async {}

  @override
  Future<void> setUserId(String id) async {}

  @override
  Future<void> setUserProperty({String name, String value}) async {}
}
