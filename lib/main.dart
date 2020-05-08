import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_drugs/app/routes/app_route_factory.dart';
import 'package:my_drugs/app/routes/app_routes.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await instantiateDatabase(await getDatabasesPath());
  final repository = AbstractDrugRepository.make(database);
  final drugs = await repository.fetchList();
  runApp(MyApp(
    repository: repository,
    analytics: FirebaseAnalytics(),
    drugs: drugs,
  ));
}

Future<Database> instantiateDatabase(String databasesPath) => openDatabase(
      // Set the path to the database.
      join(databasesPath, 'drugs_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) => db.execute(
        'CREATE TABLE drugs(id TEXT PRIMARY KEY, name TEXT, expiresOn INTEGER, createdAt INTEGER)',
      ),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

class MyApp extends StatelessWidget {
  final AppRouteFactory _routeFactory;
  final FirebaseAnalytics _analytics;

  MyApp({
    Key key,
    @required AbstractDrugRepository repository,
    @required FirebaseAnalytics analytics,
    List<Drug> drugs,
  })  : assert(repository != null),
        assert(analytics != null),
        _analytics = analytics,
        _routeFactory = AppRouteFactory(repository, analytics, drugs),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: _analytics),
      ],
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      navigatorKey: _routeFactory.navigatorKey,
      theme: _buildTheme(context),
      onGenerateRoute: (settings) =>
          _routeFactory.generateRoute(settings, context),
      initialRoute: AppRoutes.drugList,
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final baseTheme = ThemeData.light();
    final primarySwatch = Colors.teal;
    return ThemeData(
      primarySwatch: primarySwatch,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primarySwatch,
        surface: Color(0xFFFBFBFB),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[350],
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: Colors.white,
        textTheme: Theme.of(context).textTheme,
        iconTheme: IconThemeData(
          color: primarySwatch,
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: primarySwatch,
      ),
    );
  }
}
