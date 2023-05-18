import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/perlengkapan/colors.dart';

class DetailPromo extends StatefulWidget {
  const DetailPromo({super.key});

  @override
  State<DetailPromo> createState() => _DetailPromoState();
}

class _DetailPromoState extends State<DetailPromo> {
  var listItem = [];
  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/promosi'));

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

  final dateTime = DateFormat("EEEE, d MMMM yyyy", 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(86, 215, 188, 10),
        title: Text(
          "Semua Promo",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: listItem.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10.r, right: 10.r, bottom: 10.r),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                // color: Colors.white[200],
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                left: 10.w,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4.2,
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
                  top: 175.h,
                  left: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listItem[index]['title'] ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            // color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              Positioned(
                top: 195.h,
                left: 20.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Priode Promo :",
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              // color: Colors.black87,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          dateTime.format(
                              DateTime.parse(listItem[index]['tanggal'] ?? '')),
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              // color: Colors.black87,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 62.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: "Sign",
                          context: context,
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            Tween<Offset> tween;
                            tween = Tween(
                                begin: const Offset(0, -1), end: Offset.zero);
                            return SlideTransition(
                              position: tween.animate(
                                CurvedAnimation(
                                    parent: animation, curve: Curves.easeInOut),
                              ),
                              child: child,
                            );
                          },
                          pageBuilder: (context, _, __) => Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10.r, right: 10.r, bottom: 10.r),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: 10.h,
                                      right: 10.w,
                                      left: 10.w,
                                      child: CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4.2,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            'http://10.0.2.2:8000/uploads/${listItem[index]['img']}',
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.black12,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: Colors.black12,
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 175.h,
                                        left: 10.w,
                                        child: Text(
                                          listItem[index]['title'] ?? '',
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Positioned(
                                        top: 195.h,
                                        left: 10.w,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Priode Promo :",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              width: 97.w,
                                            ),
                                            Text(
                                              dateTime.format(DateTime.parse(
                                                  listItem[index]['tanggal'] ??
                                                      '')),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        )),
                                    const Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: -40,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                        width: 100.w,
                        // height: 50,
                        color: const Color.fromRGBO(86, 215, 188, 10)
                            .withOpacity(0.8),
                        child: Center(
                          child: Text(
                            "Lihat Detail",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
