import 'dart:convert';
import 'dart:io';

import 'package:baddelbook/main.dart';
import 'package:baddelbook/utils/helper/helper_widget.dart';
import 'package:baddelbook/view/widget/form_filedtext.dart';
import 'package:baddelbook/view/widget/update_data_sheet.dart';
import 'package:baddelbook/viewModel/langchange.dart';
import 'package:baddelbook/view/widget/book_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/book.dart';
import '../../model/user.dart';
import '../../viewModel/login_viewmodel.dart';
import '../widget/add_book.dart';
import '../widget/loading_widget.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 220,
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 130,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 160,
                                    width: 160,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(39),
                                          child: Container(
                                            height: 147,
                                            width: 147,
                                            color: Get.theme.textSelectionColor,
                                            child: CachedNetworkImage(
                                              imageUrl: user.imageUrl ?? "",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(child: CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.person),
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    imgFromGallery();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Get.theme
                                                          .textSelectionColor,
                                                      size: 18,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Get.theme.cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.specialization ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                          ),
                                        ),
                                        Text(
                                          user.studentId ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 107,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                        child: Text(
                                      'name'.tr,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                user.fullName ?? '',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .textSelectionColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                editData();
                                              },
                                              child: Container(
                                                child: SvgPicture.asset(
                                                    'images/Iconedit.svg'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 107,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                        child: Text(
                                      'phone'.tr,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                user.phoneNumber ?? "",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .textSelectionColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 78,
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     editData();
                                            //   },
                                            //   child: Container(
                                            //     child: SvgPicture.asset(
                                            //         'images/Iconedit.svg'),
                                            //   ),
                                            // ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'myBook'.tr,
                  style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                IconButton(
                    onPressed: () {
                      HelperWidgets.showSheet(
                          child: AddBook(edit: false), title: 'addBook'.tr);
                    },
                    icon: Icon(
                      Icons.add_box_sharp,
                      color: Get.theme.cardColor,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 200,
            child: FutureBuilder(
                future: getData(),
                builder: (context, AsyncSnapshot<List<Book>> data) {
                  if (data.connectionState == ConnectionState.waiting)
                    return LoadingWidget();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    itemCount: data.data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BookProduct(
                          book: data.data![index],
                        ),
                      );
                      // return Text('BOOK WAS HERE');
                    },
                  );
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GetBuilder<ControllerAnimated>(
                init: ControllerAnimated(),
                builder: (controller) {
                  return Center(
                    child: Container(
                      height: 41,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).accentColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.changeLanguage('en');
                                },
                                child: AnimatedContainer(
                                  height: 34,
                                  duration: Duration(
                                      milliseconds:
                                          controller.appLanguage == 'en'
                                              ? 200
                                              : 0),
                                  decoration: BoxDecoration(
                                      color: controller.appLanguage == 'en'
                                          ? Theme.of(context).backgroundColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('images/engilsh.svg'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'English',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.changeLanguage('ar');
                                },
                                child: AnimatedContainer(
                                  height: 34,
                                  duration: Duration(
                                      milliseconds:
                                          controller.appLanguage == 'ar'
                                              ? 200
                                              : 0),
                                  decoration: BoxDecoration(
                                      color: controller.appLanguage == 'ar'
                                          ? Theme.of(context).backgroundColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'العربية',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.asset('images/arabic.svg'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: ()async{
                    HelperWidgets.loading();
                      themeMode.value=(themeMode.value==ThemeMode.dark?ThemeMode.light:ThemeMode.dark);
                     Get.changeThemeMode(themeMode.value);
                      setState(() {
                      });
                      await Future.delayed(Duration(milliseconds:500));
                      Get.back();
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.accentColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.wb_twighlight,color: Get.theme.textSelectionColor,),
                          SizedBox(width: 20,),
                          Text(
                            themeMode.value==ThemeMode.dark?'lightMode'.tr:"darkMode".tr,
                            style: TextStyle(
                                color:Get.theme.textSelectionColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GetBuilder<LoginController>(
                    init: LoginController(),
                    builder: (con) {
                      return InkWell(
                        onTap: () {
                          con.logout();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Theme.of(context).textSelectionColor,
                            ),
                            Text(
                              'signOut'.tr,
                              style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
          SizedBox(
            height: 140,
          )
        ],
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

  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    HelperWidgets.loading();
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      var path = ref.putFile(_photo!);
      String? url;
      await path.whenComplete(() async {
        url = await path.snapshot.ref.getDownloadURL();
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid.value)
          .update({'image_url': url});
      Get.back();
      print(url);
    } catch (e) {
      print('error occured');
      Get.back();
    }
  }

  editData() {
    HelperWidgets.showSheet(
        child: UpdateDataSheet(), title: 'updateProfile'.tr);
  }
}
