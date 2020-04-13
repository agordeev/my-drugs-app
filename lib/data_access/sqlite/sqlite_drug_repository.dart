part of '../data_access.dart';

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
    final maps = await _database.query('dogs');
    List<Drug> result = [];
    maps.forEach((e) {
      try {
        final drug = Drug(
          id: e['id'],
          name: e['name'],
          expiresOn: e['expiresOn'],
          createdAt: e['createdAt'],
        );
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
      drug.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return drug;
  }
}
