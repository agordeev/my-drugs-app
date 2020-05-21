import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_drugs/models/model.dart';

part 'drug.g.dart';

/// The main model. Represents a med.
@JsonSerializable()
class Drug extends Model {
  @JsonKey(required: true, disallowNullValue: true)
  final String name;
  @JsonKey(required: true, disallowNullValue: true)
  final DateTime expiresOn;
  @JsonKey(required: true, disallowNullValue: true)
  final DateTime createdAt;

  String _lowercasedName;

  /// Used to speed up search.
  String get lowercasedName => _lowercasedName ?? name.toLowerCase();

  Drug({
    @required String id,
    @required this.name,
    @required this.expiresOn,
    @required this.createdAt,
  })  : assert(id != null),
        assert(name != null),
        assert(expiresOn != null),
        assert(createdAt != null),
        _lowercasedName = name.toLowerCase(),
        super(id);

  factory Drug.fromJson(Map json) => _$DrugFromJson(json);

  Map<String, dynamic> toJson() => _$DrugToJson(this);
}
