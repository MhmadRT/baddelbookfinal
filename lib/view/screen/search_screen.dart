import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/book.dart';
import '../widget/book_product.dart';
import '../widget/loading_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'search'.tr,
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 45,
              child: TextFormField(
                controller: search,
                onChanged: (c) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  filled: true,

                  hintText: "search".tr,
                  // ignore: deprecated_member_use
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<List<Book>> data) {
                if (data.connectionState == ConnectionState.waiting)
                  return LoadingWidget();
                return GridView.builder(
                  padding: EdgeInsets.all(20),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 9.0,
                      childAspectRatio: .7),
                  itemCount: data.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BookProduct(book: data.data![index]);
                  },
                );
              }),
        ],
      ),
    );
  }


  Future<List<Book>> getData() async {
    List<Book> books = [];

    var query = FirebaseFirestore.instance
        .collection('Books')
        .where('search_keys', arrayContains: search.text);
    QuerySnapshot querySnapshot = await query.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((book) {
      books.add(Book.fromJson(json.decode(json.encode(book))));
    });
    return books;
  }
}
