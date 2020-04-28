import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';
import 'package:sqflite/sqlite_api.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  Drug _testDrug;
  Database _database;
  SqliteDrugRepository _sut;

  setUp(() {
    _database = MockDatabase();
    _testDrug = Drug(
      id: 'id',
      name: 'Test drug',
      expiresOn: DateTime(2020, 10),
      createdAt: DateTime(2020, 1, 15, 22, 0, 15),
    );
    _sut = SqliteDrugRepository(_database);
  });
  group('fetchList', () {
    test('should return empty list if no rows in table', () async {
      // Arrange
      when(_database.query('drugs'))
          .thenAnswer((realInvocation) => Future.value([]));
      // Act
      final result = await _sut.fetchList();
      // Assert
      expect(result.isEmpty, true);
    });

    test('should return drugs if there are valid rows in table', () async {
      // Arrange
      when(_database.query('drugs')).thenAnswer(
        (realInvocation) => Future.value(
          [
            _testDrug.toJson(),
          ],
        ),
      );
      // Act
      final result = await _sut.fetchList();
      // Assert
      expect(result.isNotEmpty, true);
      expect(
        result[0].id,
        _testDrug.id,
      );
      expect(
        result[0].name,
        _testDrug.name,
      );
      expect(
        result[0].expiresOn,
        _testDrug.expiresOn,
      );
      expect(
        result[0].createdAt,
        _testDrug.createdAt,
      );
    });

    test('should return empty list if there is an invalid row', () async {
      // Arrange
      when(_database.query('drugs')).thenAnswer(
        (realInvocation) => Future.value(
          [
            {'invalid json': true},
          ],
        ),
      );
      // Act
      final result = await _sut.fetchList();
      // Assert
      expect(result.isEmpty, true);
    });
  });

  group('store', () {
    test('should call database.insert with ConflictAlgorithm.replace',
        () async {
      // Arrange
      // Act
      await _sut.store(_testDrug);
      // Assert
      verify(_database.insert(
        'drugs',
        _testDrug.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ));
    });
    test(
        'should not throw an exception if a record with such id already exists',
        () async {
      // Arrange
      _database.insert(
        'drugs',
        _testDrug.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // Act
      await _sut.store(_testDrug);
      // Assert
      expect(await _sut.store(_testDrug), _testDrug);
    });
  });

  group('delete', () {
    test('should call database.delete', () async {
      // Arrange
      // Act
      await _sut.delete([_testDrug.id]);
      // Assert
      verify(
        _database.delete(
          'drugs',
          where: 'id IN (?)',
          whereArgs: [_testDrug.id],
        ),
      );
    });
  });
}
