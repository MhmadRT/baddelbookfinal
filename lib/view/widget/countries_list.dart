import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/countries_codes.dart';
import '../../viewModel/login_viewmodel.dart';
import 'form_filedtext.dart';

List<Country> countries = codes.map((e) => Country.fromJson(e)).toList();

class CountriesList extends StatefulWidget {
  const CountriesList({
    Key? key,
  }) : super(key: key);

  @override
  _CountriesListState createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  String search = '';
  List<Country> result = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormFieldText(
                sIcon: const Icon(Icons.search),
                onChanged: (v) {
                  search = v;

                  if (v.isEmpty) {
                    result.clear();
                  } else {
                    result.clear();
                    for (var element in countries) {
                      if (element.name!
                              .toLowerCase()
                              .contains(search.toLowerCase()) ||
                          element.code!
                              .toLowerCase()
                              .contains(search.toLowerCase()) ||
                          element.dialCode!
                              .toLowerCase()
                              .contains(search.toLowerCase())) {
                        result.add(element);
                      }
                    }
                    setState(() {});
                  }
                },
                hints: 'search'.tr,
              ),
              GetBuilder<LoginController>(
                  init: LoginController(),
                  builder: (controller) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(25),
                        itemCount:
                            result.isEmpty ? countries.length : result.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.countryCode = result.isEmpty
                                  ? countries[index]
                                  : result[index];
                              controller.update();
                              Get.back();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${(result.isEmpty ? countries[index] : result[index]).code!} -- ${(result.isEmpty ? countries[index] : result[index]).dialCode!} -- ${(result.isEmpty ? countries[index] : result[index]).name!}",
                                  style:  TextStyle(
                                    fontFamily: '',
                                    color: Get.theme.textSelectionColor
                                  ),
                                ),
                                const Divider(
                                  height: 30,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

List<Country> countryFromJson(String str) =>
    List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  Country({
    this.name,
    this.code,
    this.dialCode,
  });

  String? name;
  String? code;
  String? dialCode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json["name"],
        code: json["code"],
        dialCode: json["dial_code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "dial_code": dialCode,
      };
}
