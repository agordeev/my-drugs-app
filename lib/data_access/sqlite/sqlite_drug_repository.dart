part of '../data_access.dart';

@visibleForTesting
class SqliteDrugRepository implements AbstractDrugRepository {
  final Database _database;
  final String _tableName = 'drugs';

  SqliteDrugRepository(this._database);

  @override
  Future<void> delete(List<String> ids) async {
    if (ids == null || ids.isEmpty) {
      return;
    }
    final placeholders = List.generate(ids.length, (index) => '?').join(',');
    await _database.delete(
      _tableName,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  @override
  Future<List<Drug>> fetchList() async {
    final maps = await _database.query(_tableName);
    final result = <Drug>[];
    for (final map in maps) {
      try {
        final drug = Drug.fromJson(map);
        result.add(drug);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

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
