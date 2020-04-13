part of '../data_access.dart';

abstract class AbstractDrugRepository {
  Future<List<Drug>> fetchList();
  Future<Drug> store(Drug drug);
  Future<void> delete(Drug drug);
}
