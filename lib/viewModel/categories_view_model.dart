import 'dart:convert';

import 'package:baddelbook/model/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/book.dart';

class CategoriesController extends GetxController {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Sections');
  bool loading = true;
  List<Category> categories = [];

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
    allData.forEach((category) {
      categories.add(Category.fromJson(json.decode(json.encode(category))));
    });
    loading = false;
    update();
  }
}
