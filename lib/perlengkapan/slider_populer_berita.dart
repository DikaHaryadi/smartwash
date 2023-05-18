import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/perlengkapan/isi_berita.dart';
import 'package:mobile/perlengkapan/isi_populer_berita.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderCarouselPopuler extends StatefulWidget {
  const SliderCarouselPopuler({super.key});

  @override
  State<SliderCarouselPopuler> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<SliderCarouselPopuler> {
  var listItem = [];

  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/populer-berita'));

      if (response.statusCode == 200) {
        var isi = json.decode(response.body);
        setState(() {
          listItem = isi;
          print('berhasil');
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        // color: Colors.transparent,
        height: MediaQuery.of(context).size.height / 2.5,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: listItem.isEmpty ? 0 : listItem.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IsiBeritaPopuler(idBerita: listItem[index]['id']),
                    ));
              },
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    height: MediaQuery.of(context).size.height / 3,
                    // color: Colors.transparent,
                  ),
                  Positioned(
                    left: 15.0,
                    top: 30.0,
                    bottom: 150.0,
                    right: 20.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.8,
                      height: MediaQuery.of(context).size.height / 3,
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: MediaQuery.of(context).size.height / 3,
                        fit: BoxFit.cover,
                        imageUrl:
                            'http://10.0.2.2:8000/uploads/${listItem[index]['img']}',
                        placeholder: (context, url) => Container(
                          color: Colors.black12,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.r,
                    top: 150.r,
                    right: 19.r,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 7,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              listItem[index]['role'] == null
                                  ? Container(
                                      color: Colors.transparent,
                                    )
                                  : Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(left: 5.w),
                                      padding: EdgeInsets.only(
                                        right: 10.w,
                                        left: 10.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(86, 215, 188, 10)
                                            .withOpacity(0.8),
                                        // borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          listItem[index]['role'] == ''
                                              ? ''
                                              : listItem[index]['role'],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.r, top: 5.r, right: 5.r),
                            child: Text(
                              listItem[index]['title'] == ''
                                  ? ''
                                  : listItem[index]['title'],
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  // color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
