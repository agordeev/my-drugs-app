import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_row_item.dart';

mixin AnalyticsSender {
  FirebaseAnalytics get analytics;

  int get drugsCountTotal;
  List<DrugListItem> get items;

  Future<void> sendScreenAnalytics() async {
    final userProperties = await compute(_calculateUserProperties, items);
    for (final userProperty in userProperties.entries) {
      analytics.setUserProperty(
        name: userProperty.key,
        value: userProperty.value,
      );
    }
    analytics.setUserProperty(
      name: 'drugs_count_total',
      value: '$drugsCountTotal',
    );
  }

  static Map<String, String> _calculateUserProperties(
      List<DrugListItem> items) {
    var expiredDrugsCount = 0;
    var notExpiredDrugsCount = 0;
    for (final item in items) {
      if (item is DrugListRowItem) {
        if (item.isExpired) {
          expiredDrugsCount += 1;
        } else {
          notExpiredDrugsCount += 1;
        }
      }
    }
    return {
      'drugs_count_expired': '$expiredDrugsCount',
      'drugs_count_not_expired': '$notExpiredDrugsCount',
    };
  }
}
