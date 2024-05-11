class Store {
  final String id;
  final String name;
  final String openingHours;
  final String closingHours;
  final bool available;

  Store({
    required this.id,
    required this.name,
    required this.openingHours,
    required this.closingHours,
    required this.available,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      name: json['name']['es_es'],
      openingHours: json['openingHours'],
      closingHours: json['closingHours'],
      available: json['available'],
    );
  }
}
