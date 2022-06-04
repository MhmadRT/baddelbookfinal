import 'dart:convert';

import 'package:baddelbook/model/book.dart';
import 'package:baddelbook/model/order.dart';
import 'package:baddelbook/utils/helper/helper_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/user.dart';
import '../../viewModel/login_viewmodel.dart';
import '../widget/loading_widget.dart';
import 'bookdeatils_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                'inbox'.tr,
                style: TextStyle(
                  fontSize: 39,
                  color: Get.theme.textSelectionColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FutureBuilder(
                  future: getData(),
                  builder: (context, AsyncSnapshot<List<Order>> data) {
                    if (data.connectionState == ConnectionState.waiting)
                      return LoadingWidget();
                    if (data.data?.isNotEmpty ?? false)
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: orderCard(data.data![index]),
                          );
                        },
                      );
                    return Center(
                      child: Icon(
                        Icons.inbox_sharp,
                        color: Get.theme.textSelectionColor.withOpacity(.3),
                        size: 40,
                      ),
                    );
                  }),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderCard(Order order) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).canvasColor),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.isFree == false)
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Books')
                        .doc(order.fromBook ?? '44')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData)
                        return bookCard(Book.fromJson(snapshot.data.data()));
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return LoadingWidget();
                      return Icon(
                        Icons.clear,
                        color: Colors.red,
                      );
                    },
                  ),
                if (order.isFree == false)
                  SvgPicture.asset(
                    'images/Icon1.svg',
                    height: 15,
                    width: 15,
                  ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Books')
                      .doc(order.toBook ?? '44')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData)
                      return bookCard(Book.fromJson(snapshot.data.data()));
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return LoadingWidget();
                    return Icon(
                      Icons.clear,
                      color: Colors.red,
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.isFree ?? true ? 'free'.tr : 'exchange'.tr,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          (order.status ?? '1') == '1'
                              ? 'pending'.tr
                              : (order.status ?? '1') == '3'
                                  ? 'accepted'.tr
                                  : "rejected".tr,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Container(
                          height: 11,
                          width: 11,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: (order.status ?? '1') == '1'
                                ? Colors.amber
                                : (order.status ?? '1') == '3'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Text(order.status.toString()),
            if ((order.status ?? '1') == '3')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(order.fromId ?? '')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: LoadingWidget());
                      if (snapshot.hasError)
                        return Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      if (!snapshot.hasData) return SizedBox();
                      var userData = snapshot.data;
                      if (userData.data() == null) return SizedBox();
                      UserModel user = UserModel.fromJson(
                          json.decode(json.encode(userData.data())));
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).backgroundColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  user.imageUrl ?? "",
                                  fit: BoxFit.cover,
                                  height: 36,
                                  width: 36,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  user.fullName ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).textSelectionColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: user.phoneNumber,
                                  );
                                  await launchUrl(launchUri);
                                },
                                child: Container(
                                  height: 31,
                                  width: 31,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff01B11C),
                                  ),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            if ((order.status ?? '1') == '1')
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () async {
                        HelperWidgets.loading();
                        await FirebaseFirestore.instance
                            .collection('Transactions')
                            .doc(order.id)
                            .update({'status': '3'});
                        Get.back();
                        setState(() {});
                      },
                      color: Colors.green,
                      child: Text(
                        'accept'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () async {
                        HelperWidgets.loading();
                        await FirebaseFirestore.instance
                            .collection('Transactions')
                            .doc(order.id)
                            .update({'status': '2'});
                        Get.back();
                        setState(() {});
                      },
                      color: Colors.red,
                      child: Text(
                        'reject'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget bookCard(Book book) {
    return GestureDetector(
      onTap: (){
        Get.to(BookDetails(book: book));
      },
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: book.imageUrl ?? "",
                height: 80,
                width: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              book.title ?? "",
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Order>> getData() async {
    List<Order> orders = [];
    var query = FirebaseFirestore.instance
        .collection('Transactions')
        .where('to_id', isEqualTo: uid.value);
    QuerySnapshot querySnapshot = await query.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((book) {
      orders.add(Order.fromJson(json.decode(json.encode(book))));
    });
    return orders;
  }
}
