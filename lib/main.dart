import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'features/drug_list/drug_list_screen.dart';
import 'models/drug.dart';

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
        name: 'Yet another medication',
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
        "CREATE TABLE drugs(id TEXT PRIMARY KEY, name TEXT, expiresOn INTEGER, createdAt INTEGER)",
      ),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

class MyApp extends StatelessWidget {
  final AbstractDrugRepository repository;
  final List<Drug> drugs;

  const MyApp({
    Key key,
    @required this.repository,
    @required this.drugs,
  })  : assert(repository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ThemeData.light().colorScheme.copyWith(
              surface: Colors.grey[100],
            ),
      ),
      home: BlocProvider<DrugListBloc>(
        create: (context) => DrugListBloc(
          repository,
          drugs,
        ),
        child: DrugListScreen(),
      ),
    );
  }
}
