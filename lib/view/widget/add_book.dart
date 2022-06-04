import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/book.dart';
import '../../model/category.dart';
import '../../model/user.dart';
import '../../utils/helper/helper_widget.dart';
import '../../viewModel/login_viewmodel.dart';
import 'form_filedtext.dart';
import 'loading_widget.dart';
import 'package:path/path.dart';

class AddBook extends StatefulWidget {
  final bool edit;
  final Book? book;

  const AddBook({Key? key, this.book, required this.edit}) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  Book book = Book();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.edit) {
      book = widget.book!;
      if(book.free==null){
        book.free=true;
      }
    }
    super.initState();
  }

  final GlobalKey<FormState> formPhoneKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    // HelperWidgets.loading();
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      var path = ref.putFile(_photo!);
      String? url;
      await path.whenComplete(() async {
        url = await path.snapshot.ref.getDownloadURL();
      });
      book.imageUrl = url;
      print(url);
    } catch (e) {
      print('error occured');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formPhoneKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  if (book.imageUrl != null)
                    SizedBox(
                      height: 160,
                      width: 120,
                      child: Stack(
                        children: [
                          Container(
                            height: 160,
                            width: 120,
                            color: Get.theme.textSelectionColor,
                            child: CachedNetworkImage(
                              imageUrl: book.imageUrl ?? "",
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.scaffoldBackgroundColor
                                    .withOpacity(0.5),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    book.imageUrl = null;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  if (_photo?.path == null && book.imageUrl == null)
                    InkWell(
                      onTap: () {
                        imgFromGallery();
                      },
                      child: Container(
                        height: 160,
                        width: 120,
                        color: Get.theme.textSelectionColor,
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Get.theme.cardColor,
                          ),
                        ),
                      ),
                    ),
                  if (_photo != null)
                    SizedBox(
                      height: 160,
                      width: 120,
                      child: Stack(
                        children: [
                          Image.file(
                            _photo!,
                            height: 160,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.scaffoldBackgroundColor
                                    .withOpacity(0.5),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    _photo = null;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FormFieldText(
              label: 'title'.tr,
              initialValue: widget.book?.title,
              validator: (v) {
                return v?.isEmpty ?? true ? 'invalid'.tr : null;
              },
              onChanged: (v) {
                book.title = v;
              },
            ),
            SizedBox(
              height: 20,
            ),
            FormFieldText(
              label: 'description'.tr,
              maxLines: 4,
              validator: (v) {
                print(v);
                return v?.isEmpty ?? true ? 'invalid'.tr : null;
              },
              onChanged: (v) {
                book.description = v;
              },
              initialValue: book.description ?? "",
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'free'.tr,
              style: TextStyle(color: Get.theme.textSelectionColor),
            ),
            Switch(
                value: book.free ?? false,
                activeColor: Get.theme.cardColor,
                onChanged: (v) {
                  book.free = v;
                  setState(() {});
                }),
            const SizedBox(
              height: 25,
            ),
            Text(
              'category'.tr,
              style: TextStyle(color: Get.theme.textSelectionColor),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Sections')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return LoadingWidget();
                  var items = snapshot.data?.docs ?? [];
                  List<Category> categories = [];
                  items.forEach((element) {
                    categories.add(
                        Category(name: element['name'], id: element['id']));
                  });
                  return Wrap(
                    children: [
                      for (var i in categories)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              book.sectionId = i.id;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: book.sectionId == i.id
                                      ? Get.theme.cardColor
                                      : Get.theme.textSelectionColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 30),
                                child: Text(
                                  i.name ?? "",
                                  style: TextStyle(
                                      color: Get.theme.scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                }),
            const SizedBox(
              height: 25,
            ),
            Text(
              'bookStatus'.tr,
              style: TextStyle(color: Get.theme.textSelectionColor),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('BookStatuse')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return LoadingWidget();
                  var items = snapshot.data?.docs ?? [];
                  List<Category> categories = [];
                  items.forEach((element) {
                    categories.add(
                        Category(name: element['name'], id: element['id']));
                  });
                  return Wrap(
                    children: [
                      for (var i in categories)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              book.bookStatus = i.id;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: book.bookStatus == i.id
                                      ? Get.theme.cardColor
                                      : Get.theme.textSelectionColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 30),
                                child: Text(
                                  i.name ?? "",
                                  style: TextStyle(
                                      color: Get.theme.scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                }),
            const SizedBox(
              height: 25,
            ),
            Text(
              'bookAge'.tr,
              style: TextStyle(color: Get.theme.textSelectionColor),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if ((book.bookAge ?? 0) > 0)
                        book.bookAge = (book.bookAge ?? 0) - 1;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.indeterminate_check_box_sharp,
                      color: Get.theme.cardColor,
                    )),
                Text(
                  '${book.bookAge ?? 0}',
                  style: TextStyle(color: Get.theme.textSelectionColor),
                ),
                IconButton(
                    onPressed: () {
                      book.bookAge = (book.bookAge ?? 0) + 1;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.add_box_sharp,
                      color: Get.theme.cardColor,
                    )),
              ],
            ),
            GestureDetector(
              onTap: () async {
                print('update');
                if (formPhoneKey.currentState?.validate() ?? false) {
                  HelperWidgets.loading();
                  if(_photo!=null)
                  await uploadFile();
                  book.setSearchKey();
                  if (widget.edit) {
                    await FirebaseFirestore.instance
                        .collection('Books')
                        .doc(book.id)
                        .update(book.toJson())
                        .then((value) {
                      print(uid.value);
                    });
                  }
                  else {
                    var doc = await FirebaseFirestore.instance
                        .collection('Books')
                        .doc();
                    book.id = doc.id;
                    book.ownerId = uid.value;
                    await doc.set(book.toJson()).then((value) {
                      print(uid.value);
                    });
                  }
                  Get.back();
                  Get.back();
                }
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Get.theme.primaryColor,
                ),
                child: Center(
                  child: Text(
                    "save".tr,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}
