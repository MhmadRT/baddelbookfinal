import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'LOGOTAGHERO',
      child: SizedBox(
        width: 150,
        child: SvgPicture.asset(
          'images/logo2.svg',
        ),
      ),
    );
  }
}