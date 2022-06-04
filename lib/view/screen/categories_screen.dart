import 'dart:convert';

import 'package:baddelbook/model/category.dart';
import 'package:baddelbook/view/widget/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'category_screen.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'categories'.tr,
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Gotham',
              fontWeight: FontWeight.bold),
        ),
      ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Sections').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LoadingWidget();
              var items = snapshot.data?.docs ?? [];
              List<Category> categories = [];
              items.forEach((element) {
                categories
                    .add(Category(name: element['name'], id: element['id']));
              });
              return GridView.builder(
                padding: EdgeInsets.all(20),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.to(CategoryScreen(
                        category: categories[index],
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
                          categories[index].name ?? "",
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
    );
  }
}
