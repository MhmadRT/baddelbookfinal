import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../viewModel/imagebook_viewmodel.dart';

class ImageBookScreen extends StatelessWidget {
  const ImageBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageViewModel>(
        init: ImageViewModel(),
        builder: (controller) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 651,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      itemCount: 4,
                      onPageChanged: (value) {
                        controller.selectedIndex = value;
                        controller.update();
                      },
                      pageSnapping: true,
                      padEnds: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Image.network(
                          'https://kbimages1-a.akamaihd.net/80708cef-c25e-4f88-83a7-d3ebf23e7e20/1200/1200/False/introduction-to-java-programming.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indecaters(3, controller.selectedIndex),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, right: 0, bottom: 0, left: 30),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: SvgPicture.asset(
                          'images/cancelIcon.svg',
                        ),
                      ),
                    )),
              )
            ],
          );
        });
  }

  List<Widget> indecaters(int count, int index) {
    List<Widget> widgets = [];
    for (int i = 0; i < count; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: i == index
                  ? Container(
                      height: 64,
                      child: Image.network(
                        'https://kbimages1-a.akamaihd.net/80708cef-c25e-4f88-83a7-d3ebf23e7e20/1200/1200/False/introduction-to-java-programming.jpg',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 64,
                      child: Image.network(
                        'https://kbimages1-a.akamaihd.net/80708cef-c25e-4f88-83a7-d3ebf23e7e20/1200/1200/False/introduction-to-java-programming.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
