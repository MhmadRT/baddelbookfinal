class Category {
  final String? name;
  final String? id;

  Category({
    this.name,
    this.id,
  });

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'id' : id
  };
}