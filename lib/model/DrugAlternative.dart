class DrugAlternative {
  final int id;
  final String name;
  final String composition;
  final String className; // Using className instead of class (reserved keyword)
  final String company;
  final String price;

  DrugAlternative({
    required this.id,
    required this.name,
    required this.composition,
    required this.className,
    required this.company,
    required this.price,
  });

  factory DrugAlternative.fromJson(Map<String, dynamic> json) {
    return DrugAlternative(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      composition: json['composition'] ?? '',
      className: json['class'] ?? '',
      company: json['company'] ?? '',
      price: json['price'] ?? '',
    );
  }

  @override
  String toString() {
    return 'DrugAlternative{id: $id, name: $name, composition: $composition, className: $className, company: $company, price: $price}';
  }
}
