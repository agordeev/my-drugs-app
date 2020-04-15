abstract class DrugListItem {}

class DrugHeadingItem extends DrugListItem {
  final String name;

  DrugHeadingItem(this.name);
}

class DrugItem extends DrugListItem {
  final String id;
  final String name;
  final String expiresOn;

  DrugItem(
    this.id,
    this.name,
    this.expiresOn,
  );
}
