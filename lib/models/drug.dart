import 'package:flutter/foundation.dart';
import 'package:my_drugs/models/model.dart';

/// The main model. Represents a med.
class Drug extends Model {
  final String name;
  final DateTime expiresOn;
  final DateTime createdAt;

  Drug({
    @required String id,
    @required this.name,
    @required this.expiresOn,
    @required this.createdAt,
  })  : assert(id != null),
        assert(name != null),
        assert(expiresOn != null),
        assert(createdAt != null),
        super(id);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expiresOn': expiresOn,
      'createdAt': createdAt,
    };
  }
}
