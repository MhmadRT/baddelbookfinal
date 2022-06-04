import 'dart:convert';

import 'package:baddelbook/model/book.dart';
import 'package:baddelbook/model/category.dart';
import 'package:baddelbook/view/widget/book_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/loading_widget.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController search = TextEditingController();

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.category.name ?? '',
          style: TextStyle(
              color: Get.theme.textSelectionColor,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
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
                    fillColor: Theme.of(context).accentColor,
                    filled: true,

                    hintText: "search".tr,
                    // ignore: deprecated_member_use
                    suffixIcon: Icon(
                      Icons.search,
                      color: Get.theme.textSelectionColor,
                    ),
                    hintStyle: TextStyle(
                        color: Get.theme.textSelectionColor,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 41,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).accentColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectedIndex = 0;
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: Duration(
                                milliseconds: selectedIndex == 0 ? 200 : 0),
                            decoration: BoxDecoration(
                                color: selectedIndex == 0
                                    ? Theme.of(context).backgroundColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'exchange'.tr,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).textSelectionColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectedIndex = 1;
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: Duration(
                                milliseconds: selectedIndex == 1 ? 200 : 0),
                            decoration: BoxDecoration(
                                color: selectedIndex == 1
                                    ? Theme.of(context).backgroundColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'all'.tr,
                                  style: TextStyle(
                                      color: Theme.of(context).textSelectionColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectedIndex = 2;
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: Duration(
                                milliseconds: selectedIndex == 2 ? 200 : 0),
                            decoration: BoxDecoration(
                                color: selectedIndex == 2
                                    ? Theme.of(context).backgroundColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'free'.tr,
                                  style: TextStyle(
                                      color: Theme.of(context).textSelectionColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
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
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: data.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BookProduct(book: data.data![index]);
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  Future<List<Book>> getData() async {
    print(widget.category.toJson());
    List<Book> books = [];
    var query = selectedIndex == 1
        ? FirebaseFirestore.instance
            .collection('Books')
            .where('section_id', isEqualTo: widget.category.id ?? '')
            .where('search_keys', arrayContains: search.text)
        : FirebaseFirestore.instance
            .collection('Books')
            .where('section_id', isEqualTo: widget.category.id ?? '')
            .where('free', isEqualTo: selectedIndex == 0 ? false : true)
            .where('search_keys', arrayContains: search.text);
    QuerySnapshot querySnapshot = await query.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((book) {
      books.add(Book.fromJson(json.decode(json.encode(book))));
    });
    return books;
  }
}
