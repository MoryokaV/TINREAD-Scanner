class Inventory {
  final int id;
  final String name;
  final String note;

  Inventory({
    required this.id,
    required this.name,
    required this.note,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      name: json['inventoryName'],
      note: json['note'],
    );
  }
}
