import 'dart:ui';

import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';

class TestDrugRepository implements AbstractDrugRepository {
  final Locale _locale;

  TestDrugRepository(this._locale);

  @override
  Future<void> delete(List<String> ids) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Drug>> fetchList() async {
    List<Drug> result;
    switch (_locale.languageCode) {
      case 'ru':
        result = _generateDrugs({
          'Аспирин': DateTime(2020, 4),
          'Ибупрофен': DateTime(2021, 12),
          'Амоксициллин': DateTime(2021, 10),
          'Нитроглицерин': DateTime(2021, 10),
          'Салициловая мазь': DateTime(2020, 1),
          'Бепантен': DateTime(2021, 4),
          'Бинт стерильный, 10 м': DateTime(2019, 12),
          'Перекись водорода, 20 мл': DateTime(2020, 3),
        });
        break;
      default:
        result = _generateDrugs({
          'Aspirin': DateTime(2020, 4),
          'Ibuprofen': DateTime(2021, 12),
          'Amoxicillin': DateTime(2021, 10),
          'Lyrica': DateTime(2021, 10),
          'Hydrocortisone ointment': DateTime(2020, 1),
          'Chantix': DateTime(2021, 4),
          '2 2"rolls of Gauze': DateTime(2019, 12),
          '24 oz. Sterile Water': DateTime(2020, 3),
        });
        break;
    }
    result
        .sort((first, second) => -first.expiresOn.compareTo(second.expiresOn));
    return result;
  }

  @override
  Future<Drug> store(Drug drug) async {
    throw UnimplementedError();
  }

  List<Drug> _generateDrugs(Map<String, DateTime> namesAndExpiryDates) {
    return namesAndExpiryDates.entries
        .map(
          (e) => Drug(
            id: e.key,
            name: e.key,
            expiresOn: e.value,
            createdAt: DateTime.now(),
          ),
        )
        .toList();
  }
}
