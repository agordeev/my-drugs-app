import 'package:flutter/material.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'features/drug_list/drug_list_screen.dart';

void main() async {
  final database = await instantiateDatabase(await getDatabasesPath());
  final repository = AbstractDrugRepository.make(database);
  runApp(MyApp(
    repository: repository,
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

  const MyApp({Key key, @required this.repository})
      : assert(repository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DrugListScreen(),
    );
  }
}
