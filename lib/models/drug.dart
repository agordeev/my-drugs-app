import 'package:my_drugs/models/model.dart';

/// The main model. Represents a med.
class Drug extends Model {
  final String name;
  final DateTime expiresOn;
  final DateTime createdAt;

  Drug(String id, this.name, this.expiresOn, this.createdAt) : super(id);
}
