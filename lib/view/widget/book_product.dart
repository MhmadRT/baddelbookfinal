import 'package:baddelbook/utils/helper/helper_widget.dart';
import 'package:baddelbook/view/screen/bookdeatils_screen.dart';
import 'package:baddelbook/view/widget/add_book.dart';
import 'package:baddelbook/viewModel/login_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/book.dart';

class BookProduct extends StatelessWidget {
  final Book book;

  const BookProduct({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: GestureDetector(
        onTap: () {
          Get.to(BookDetails(
            book: book,
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  width: 112,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: book.imageUrl ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        if (uid.value == book.ownerId)
                          InkWell(
                            onTap: () {
                              HelperWidgets.showSheet(
                                  child: AddBook(
                                    edit: true,
                                    book: book,
                                  ),
                                  title: 'editBook'.tr);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Get.theme.textSelectionColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Get.theme.cardColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              book.title ?? "",maxLines: 1,
              style: TextStyle(
                  fontSize: 15, color:Get.theme.textSelectionColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 100,
              child: Text(
                book.description ?? "",
                style: TextStyle(
                    fontSize: 13,
                    color: Get.theme.textSelectionColor,
                    fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              (book.free ?? false) ? 'free'.tr : 'exchange'.tr,maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
