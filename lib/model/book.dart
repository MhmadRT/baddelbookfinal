class Book {
  String? sectionId;
  String? description;
  String? title;
  String? id;
  int? bookAge;
  String? bookStatus;
  String? ownerId;
  String? imageUrl;
  List<String>? searchKeys;
  bool? free;

  Book({
    this.sectionId,
    this.searchKeys,
    this.free,
    this.description,
    this.title,
    this.id,
    this.bookAge,
    this.bookStatus,
    this.ownerId,
    this.imageUrl,
  });

  Book.fromJson(Map<String, dynamic> json)
      : sectionId = json['section_id'] as String?,
        description = json['description'] as String?,
        // searchKeys = json['search_keys'] ??[''],
        free = json['free'] as bool?,
        title = json['title'] as String?,
        id = json['id'] as String?,
        bookAge = json['book_age'] as int?,
        bookStatus = json['book_status'] as String?,
        ownerId = json['owner_id'] as String?,
        imageUrl = json['image_url'] as String?;

  setSearchKey() {
    searchKeys=[''];
    for (int i = 0; i < (title?.length ?? 0); i++) {
      String c = '';
      for (int j = 0; j <= i; j++) {
        c = c + title![j];
      }
      searchKeys?.add(c.toLowerCase());
      print(searchKeys);
    }
  }

  Map<String, dynamic> toJson() => {
        'section_id': sectionId,
        'description': description,
        'title': title,
        'free': free,
        'id': id,
        'book_age': bookAge,
        'search_keys': searchKeys,
        'book_status': bookStatus,
        'owner_id': ownerId,
        'image_url': imageUrl
      };
}
