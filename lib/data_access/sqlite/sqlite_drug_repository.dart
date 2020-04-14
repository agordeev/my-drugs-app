part of '../data_access.dart';

@visibleForTesting
class SqliteDrugRepository implements AbstractDrugRepository {
  final Database _database;
  final String _tableName = 'drugs';

  SqliteDrugRepository(this._database);

  @override
  Future<void> delete(String drugId) async {
    await _database.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [drugId],
    );
  }

  @override
  Future<List<Drug>> fetchList() async {
    final maps = await _database.query(_tableName);
    List<Drug> result = [];
    maps.forEach((e) {
      try {
        final drug = Drug.fromJson(e);
        result.add(drug);
      } catch (e) {
        print(e);
      }
    });

    return result;
  }

  @override
  Future<Drug> store(Drug drug) async {
    await _database.insert(
      _tableName,
      drug.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return drug;
  }
}
