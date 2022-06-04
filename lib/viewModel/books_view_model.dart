import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/book.dart';

class BooksController extends GetxController {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Books');
  bool loading = true;
  List<Book> books = [];

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    loading = true;
    update();
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((book) {
      books.add(Book.fromJson(json.decode(json.encode(book))));
    });
    loading = false;
    update();
  }
}
