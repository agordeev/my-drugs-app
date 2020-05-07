import 'dart:async';
import 'dart:convert' as c;

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/main.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  final DataHandler handler = (_) async {
    final response = {'locale': Intl.defaultLocale};
    return Future.value(c.jsonEncode(response));
  };
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  enableFlutterDriverExtension(handler: handler);
  WidgetsApp.debugAllowBannerOverride = false; // remove debug banner

  final database = await instantiateDatabase(await getDatabasesPath());
  final repository = AbstractDrugRepository.make(database);
  final drugs = await repository.fetchList();
  runApp(MyApp(
    repository: repository,
    drugs: drugs,
  ));
}
