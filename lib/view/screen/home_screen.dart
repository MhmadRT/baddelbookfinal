import 'dart:convert';

import 'package:baddelbook/model/user.dart';
import 'package:baddelbook/view/screen/category_screen.dart';
import 'package:baddelbook/view/screen/profile_screen.dart';
import 'package:baddelbook/view/screen/search_screen.dart';
import 'package:baddelbook/viewModel/books_view_model.dart';
import 'package:baddelbook/viewModel/login_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewModel/categories_view_model.dart';
import '../widget/book_product.dart';
import '../widget/loading_widget.dart';
import 'categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid.value ?? '')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: LoadingWidget());
                var userData = snapshot.data;
                UserModel user = UserModel.fromJson(
                    json.decode(json.encode(userData.data())));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          user.fullName ?? "",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 63,
                          width: 63,
                          color: Get.theme.textSelectionColor,
                          child: CachedNetworkImage(
                            imageUrl: user.imageUrl ?? "",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: InkWell(
              onTap: () {
                Get.to(SearchScreen());
              },
              child: Container(
                height: 45,
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Get.theme.accentColor,
                    filled: true,
                    hintText: "search".tr,
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
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'categories'.tr,
                  style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(CategoriesPage());
                  },
                  child: Text(
                    'showAll'.tr,
                    style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GetBuilder<CategoriesController>(
              init: CategoriesController(),
              builder: (con) {
                return con.loading
                    ? LoadingWidget()
                    : GridView.builder(
                        padding: EdgeInsets.all(20),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: con.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.to(CategoryScreen(
                                category: con.categories[index],
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: index % 3 == 0
                                      ? Get.theme.cardColor
                                      : Get.theme.textSelectionColor),
                              child: Center(
                                child: Text(
                                  con.categories[index].name ?? "",
                                  style: TextStyle(
                                      color: Get.theme.scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'books'.tr,
                  style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(SearchScreen());
                  },
                  child: Text(
                    'showAll'.tr,
                    style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GetBuilder<BooksController>(
              init: BooksController(),
              builder: (con) {
                return Container(
                    height: 200,
                    width: Get.width,
                    child: con.loading
                        ? LoadingWidget()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            shrinkWrap: true,
                            itemCount: con.books.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: BookProduct(book: con.books[index]),
                              );
                            },
                          ));
              }),
          SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }
}
