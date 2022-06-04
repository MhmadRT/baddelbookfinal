import 'dart:convert';

import 'package:baddelbook/model/order.dart';
import 'package:baddelbook/utils/helper/helper_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/book.dart';
import '../../viewModel/login_viewmodel.dart';
import '../widget/loading_widget.dart';
import '../widget/widget_type_select_book.dart';

class BookDetails extends StatefulWidget {
  final Book book;

  const BookDetails({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  Book? myBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 217,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          // Get.to(ImageBookScreen());
                        },
                        child: Container(
                          height: 160,
                          width: 120,
                          color: Get.theme.textSelectionColor,
                          child: CachedNetworkImage(
                            imageUrl: widget.book.imageUrl ?? "",
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            widget.book.title ?? "",
                            style: TextStyle(
                                fontSize: 39,
                                color: Theme.of(context)
                                    .textSelectionColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gotham'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Sections')
                                  .doc(widget.book.sectionId ?? '')
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return LoadingWidget();
                                return Text(
                                  snapshot.data?.data()?['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).textSelectionColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.book.description ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .textSelectionColor,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Gotham'),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Theme.of(context).accentColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'bookStatus'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('BookStatuse')
                                        .doc(widget.book.bookStatus ?? '')
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return LoadingWidget();
                                      return Row(
                                        children: [
                                          Text(
                                            snapshot.data.data()['name'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .textSelectionColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Color(int.parse(
                                                  '0xff${snapshot.data.data()['color']}')),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Theme.of(context).accentColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  'bookAge'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Container(
                                  height: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:Get.theme.backgroundColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        '${widget.book.bookAge} ' + 'years'.tr,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        if (widget.book.ownerId != uid.value)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!(widget.book.free ?? true))
                                Column(
                                  children: [
                                    Text(
                                      'selectExchangeWith'.tr,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                 ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    FutureBuilder(
                                        future: getData(),
                                        builder: (context,
                                            AsyncSnapshot<List<Book>> data) {
                                          if (data.connectionState ==
                                              ConnectionState.waiting)
                                            return LoadingWidget();
                                          return Wrap(
                                            spacing: 10,
                                            children: [
                                              if (data.data?.isNotEmpty ??
                                                  false)
                                                for (var i in data.data!)
                                                  InkWell(
                                                      onTap: () {
                                                        myBook = i;
                                                        setState(() {});
                                                      },
                                                      child: TypeBookSelect(
                                                          text: i.title ?? '',
                                                          selected:
                                                              myBook?.id ==
                                                                  i.id)),
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              SizedBox(
                                height: 35,
                              ),
                              MaterialButton(
                                minWidth: Get.width,
                                height: 45,
                                onPressed: () async {
                                  if ((widget.book.free ?? true)) {
                                    HelperWidgets.loading();
                                    Order order = Order();
                                    order.fromId = uid.value;
                                    order.toId = widget.book.ownerId;
                                    order.toBook = widget.book.id;
                                    order.status = '1';
                                    order.isFree = widget.book.free;
                                    var doc = await FirebaseFirestore.instance
                                        .collection('Transactions')
                                        .doc();
                                    order.id = doc.id;
                                    await doc.set(order.toJson());
                                    Get.back();
                                    HelperWidgets.errorBar(
                                        title: 'successfully',
                                        message: 'sentOrderSuccessfully',
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ));
                                  }else{
                                    if(myBook!=null){
                                      HelperWidgets.loading();
                                      Order order = Order();
                                      order.fromId = uid.value;
                                      order.fromBook=myBook?.id;
                                      order.toId = widget.book.ownerId;
                                      order.toBook = widget.book.id;
                                      order.status = '1';
                                      order.isFree = widget.book.free;
                                      var doc = await FirebaseFirestore.instance
                                          .collection('Transactions')
                                          .doc();
                                      order.id = doc.id;
                                      await doc.set(order.toJson());
                                      Get.back();
                                      HelperWidgets.errorBar(
                                          title: 'successfully'.tr,
                                          message: 'sentOrderSuccessfully'.tr,
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ));
                                    }
                                  }
                                },
                                color: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Text(
                                  "sendRequest".tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Theme.of(context).textSelectionColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Book>> getData() async {
    List<Book> books = [];
    var query = FirebaseFirestore.instance
        .collection('Books')
        .where('owner_id', isEqualTo: uid.value);
    QuerySnapshot querySnapshot = await query.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((book) {
      books.add(Book.fromJson(json.decode(json.encode(book))));
    });
    return books;
  }
}
