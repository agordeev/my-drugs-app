import 'dart:async';
import 'dart:convert' as c;

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/main.dart';

import 'mock_firebase_analytics.dart';
import 'test_drug_repository.dart';

Future<void> main() async {
  Future<String> handler(String _) {
    final response = {'locale': Intl.defaultLocale};
    return Future<String>.value(c.jsonEncode(response));
  }

  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  enableFlutterDriverExtension(handler: handler);
  WidgetsApp.debugAllowBannerOverride = false;
  const locale = Locale('en');
  final repository = TestDrugRepository(locale);
  final drugs = await repository.fetchList();
  runApp(MyApp(
    repository: repository,
    analytics: MockFirebaseAnalytics(),
    drugs: drugs,
  ));
}
