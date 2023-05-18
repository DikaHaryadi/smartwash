import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/perlengkapan/isi_category.dart';
import 'package:mobile/perlengkapan/isi_paket_category.dart';

class PaketCategory extends StatefulWidget {
  const PaketCategory({super.key});

  @override
  State<PaketCategory> createState() => _PaketCategoryState();
}

class _PaketCategoryState extends State<PaketCategory> {
  var listItem = [];
  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/paket-bersih'));

      if (response.statusCode == 200) {
        var isi = json.decode(response.body);
        setState(() {
          listItem = isi;
        });
      } else {
        print("Ada Yang Salah");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  final formater =
      NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              "Paket Terbaik dari SmartWash",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Ionicons.newspaper_outline,
                  color: Colors.grey.shade600,
                ),
              )
            ],
          )
        ],
        body: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IsiPaketCategory(
                            idBerita: listItem[index]['id'],
                            harga: int.parse(listItem[index]['harga']),
                            isiPaket: listItem[index]['title'])));
              },
              child: Container(
                margin: EdgeInsets.only(left: 10.r, right: 10.r, bottom: 10.r),
                padding: EdgeInsets.only(bottom: 15.r),
                color: const Color.fromRGBO(86, 215, 188, 10).withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                      ),
                      child: Text(listItem[index]['title'],
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Poppins', fontSize: 16.sp)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        formater.format(double.parse(listItem[index]['harga'])),
                        style: TextStyle(fontFamily: 'Intels', fontSize: 12.sp),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        listItem[index]['deskripsi'],
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: listItem.isEmpty ? 0 : listItem.length,
        ),
      ),
    );
  }
}
