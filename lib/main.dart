import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drugs/app/routes/app_route_factory.dart';
import 'package:my_drugs/app/routes/app_routes.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await instantiateDatabase(await getDatabasesPath());
  final repository = AbstractDrugRepository.make(database);
  runApp(MyApp(
    repository: repository,
    drugs: [
      Drug(
        id: '1',
        name: 'Name',
        expiresOn: DateTime(2020, 1),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '2',
        name: 'Aspirin',
        expiresOn: DateTime(2020, 10),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '3',
        name: 'A medication with very long name to test multiline',
        expiresOn: DateTime(2020, 4),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '4',
        name:
            '4 Irst art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier',
        expiresOn: DateTime(2020, 11),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '5',
        name:
            '5 Irst art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier',
        expiresOn: DateTime(2020, 11),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '6',
        name:
            '6 Irst art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier',
        expiresOn: DateTime(2020, 11),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '7',
        name:
            '7 Irst art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier',
        expiresOn: DateTime(2020, 11),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '8',
        name:
            '8 Irst art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier art ier',
        expiresOn: DateTime(2020, 11),
        createdAt: DateTime.now(),
      ),
    ],
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

  MyApp({
    Key key,
    @required AbstractDrugRepository repository,
    List<Drug> drugs,
  })  : assert(repository != null),
        _routeFactory = AppRouteFactory(repository, drugs),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
