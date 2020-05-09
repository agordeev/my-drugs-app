import 'dart:async';
import 'dart:convert' as c;

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/main.dart';

import 'mock_firebase_analytics.dart';
import 'test_drug_repository.dart';

void main() async {
  final handler = (String _) async {
    final response = {'locale': Intl.defaultLocale};
    return Future<String>.value(c.jsonEncode(response));
  };
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  enableFlutterDriverExtension(handler: handler);
  WidgetsApp.debugAllowBannerOverride = false;
  final locale = Locale('ru');
  final repository = TestDrugRepository(locale);
  final drugs = await repository.fetchList();
  runApp(MyApp(
    repository: repository,
    analytics: MockFirebaseAnalytics(),
    drugs: drugs,
  ));
}
