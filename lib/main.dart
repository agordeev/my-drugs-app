import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_drugs/app/routes/app_route_factory.dart';
import 'package:my_drugs/app/routes/app_routes.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';
import 'package:path/path.dart' as path;
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
    drugs: [
      Drug(
        id: '1',
        name: '1',
        expiresOn: DateTime(2021, 1),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '2',
        name: '2',
        expiresOn: DateTime(2021, 2),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '3',
        name: '3',
        expiresOn: DateTime(2021, 3),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '4',
        name: '4',
        expiresOn: DateTime(2021, 4),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '5',
        name: '5',
        expiresOn: DateTime(2021, 5),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '6',
        name: '6',
        expiresOn: DateTime(2021, 6),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '1 exp',
        name:
            '1 exp arstianrast inrasiot nrseiotnwfyupl uynrst uaroiesnt oierasntieor sntyuwfpnrsnat riesantieorsant ieorasnt wyfun raisetn rioesntoir',
        expiresOn: DateTime(2020, 1),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '2 exp',
        name:
            '2 exp arie tsn ra ensth ri oern rsti reitn ri sier rsei rsie rier sif',
        expiresOn: DateTime(2020, 2),
        createdAt: DateTime.now(),
      ),
      Drug(
        id: '3 exp',
        name: '3 exp',
        expiresOn: DateTime(2020, 3),
        createdAt: DateTime.now(),
      ),
    ],
    // drugs: List.generate(
    //       500,
    //       (index) => Drug(
    //         id: '$index',
    //         name: '$index',
    //         expiresOn: DateTime(2020, 1),
    //         createdAt: DateTime.now(),
    //       ),
    //     ) +
    //     List.generate(
    //       100,
    //       (index) => Drug(
    //         id: '$index',
    //         name: '$index',
    //         expiresOn: DateTime(2021, 1),
    //         createdAt: DateTime.now(),
    //       ),
    //     ),
  ));
}

Future<Database> instantiateDatabase(String databasesPath) => openDatabase(
      // Set the path to the database.
      path.join(databasesPath, 'drugs_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) => db.execute(
        'CREATE TABLE drugs(id TEXT PRIMARY KEY, name TEXT, expiresOn INTEGER, createdAt INTEGER)',
      ),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

class MyApp extends StatefulWidget {
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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() async {
    await precacheImage(
      AssetImage('assets/images/drug_list_empty_state.png'),
      context,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: widget._analytics),
      ],
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      navigatorKey: widget._routeFactory.navigatorKey,
      theme: _buildTheme(context),
      onGenerateRoute: (settings) =>
          widget._routeFactory.generateRoute(settings, context),
      initialRoute: AppRoutes.drugList,
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final baseTheme = ThemeData.light();
    final primaryColor = Color(0xFFf05b6c);
    return ThemeData(
      primaryColor: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryColor,
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
          color: primaryColor,
        ),
      ),
    );
  }
}
