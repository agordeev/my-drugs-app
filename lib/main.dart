import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  final drugs = await repository.fetchList();
  runApp(MyApp(
    repository: repository,
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
      supportedLocales: [
        const Locale('en'),
        const Locale('ru'),
      ],
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: 'assets/i18n/',
            decodeStrategies: [YamlDecodeStrategy()],
          ),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
