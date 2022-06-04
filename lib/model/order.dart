class Order {
   String? fromBook;
   String? id;
   String? fromId;
   bool? isFree;
   String? status;
   String? toBook;
   String? toId;

  Order({
    this.fromBook,
    this.id,
    this.fromId,
    this.isFree,
    this.status,
    this.toBook,
    this.toId,
  });

  Order.fromJson(Map<String, dynamic> json)
      : fromBook = json['from_book'] as String?,
        fromId = json['from_id'] as String?,
        isFree = json['is_free'] as bool?,
        id = json['id'] as String?,
        status = json['status'] as String?,
        toBook = json['to_book'] as String?,
        toId = json['to_id'] as String?;

  Map<String, dynamic> toJson() => {
    'from_book' : fromBook,
    'id' : id,
    'from_id' : fromId,
    'is_free' : isFree,
    'status' : status,
    'to_book' : toBook,
    'to_id' : toId
  };
}