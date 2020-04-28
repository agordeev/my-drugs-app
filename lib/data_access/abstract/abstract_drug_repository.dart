part of '../data_access.dart';

abstract class AbstractDrugRepository {
  factory AbstractDrugRepository.make(Database database) =>
      SqliteDrugRepository(database);

  Future<List<Drug>> fetchList();
  Future<Drug> store(Drug drug);
  Future<void> delete(List<String> ids);
}
