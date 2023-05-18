import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile/detail_promo.dart';
import 'package:mobile/login.dart';
import 'package:mobile/perlengkapan/colors.dart';
import 'package:mobile/perlengkapan/isi_category.dart';
import 'package:mobile/perlengkapan/promosi.dart';
import 'package:mobile/perlengkapan/slider_populer_berita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/main.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/perlengkapan/carousel_slider.dart';
import 'package:mobile/perlengkapan/detail_berita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

import 'Animated Navigation/components/menu.dart';
import 'appbar profile/appbar_widget.dart';

class Beranda extends StatefulWidget {
  Beranda({
    Key? key,
  }) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  var listItem = [];
  final _prefs = SharedPreferences.getInstance();
  String name = '';

  _getUserData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  final List<String> imageList = [
    "assets/images/promosi1.png",
    "assets/images/promosi2.png",
    "assets/images/promosi3.png",
  ];

  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/kategori'));

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
    _getUserData().then((_) {
      _getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 15,
                  padding: EdgeInsets.only(
                    left: 10.r,
                    right: 10.r,
                    top: 5.r,
                    bottom: 5.r,
                  ),
                  margin: EdgeInsets.only(bottom: 10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontFamily: 'Intels',
                                fontSize: 14.sp,
                                color: Colors.grey.shade600),
                          ),
                          Icon(
                            Ionicons.logo_paypal,
                            color: Colors.blue.shade400,
                          )
                        ],
                      ),
                      Text(
                        'Hubungkan PayPal',
                        style: TextStyle(
                            fontFamily: 'Intels',
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: listItem.isEmpty ? 0 : listItem.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) => Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IsiCategory(
                                  idBerita: listItem[index]['id'],
                                  category: listItem[index]['title'],
                                  harga: int.parse(
                                    listItem[index]['harga'],
                                  ),
                                  satuan: listItem[index]['satuan'],
                                ),
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 13),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          listItem[index]['plus'] == null
                              ? Container(
                                  color: Colors.transparent,
                                )
                              : Container(
                                  height: 25.h,
                                  margin:
                                      EdgeInsets.only(right: 15.r, top: 5.r),
                                  padding:
                                      EdgeInsets.only(right: 5.r, left: 5.r),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(86, 215, 188, 10)
                                            .withOpacity(0.8),
                                    // borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        LineIcons.plusCircle,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        listItem[index]['plus'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                            height: 50.h,
                            margin: EdgeInsets.only(left: 10.r, right: 12.r),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: Center(
                              child: Text(
                                listItem[index]['title'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailPromo(),
                            ));
                      },
                      child: Container(
                        height: 50,
                        width: 70,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Center(
                            child: Text(
                          "All",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailPromo(),
                            ));
                      }),
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Center(
                            child: Text(
                          "Promo",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return Center(
                                child: Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Image(
                                          image: NetworkImage(
                                        "https://media1.tenor.com/images/7cf8d1f537e31b421d38912fa798cb99/tenor.gif?itemid=4362122",
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0, right: 10.0),
                                        child: Text(
                                          "Saya sebagai developer aplikasi ini memohon maaf kepada para pelanggan dikarenakan belum tersedianya fitur ini",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              // color: Colors.black,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.exit_to_app),
                                        label: const Text("Keluar"),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 50,
                        width: 110,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Center(
                            child: Text(
                          "Partnership",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    RichText(
                        text: TextSpan(
                            text: "Lihat Semua",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DetailPromo(),
                                    ));
                              },
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ))),
                  ],
                ),
                SizedBox(height: 10.h),
                const PromosiCarousel(),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 20,
                  color:
                      const Color.fromRGBO(86, 215, 188, 10).withOpacity(0.8),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Marquee(
                    text:
                        "Hallo ${name.toUpperCase()},  Ayo Pesan Sekarang Dengan Menggunakan Kode Promo Bulan Ini.",
                    blankSpace: 20.0,
                    velocity: 50.0, //speed
                    // pauseAfterRound: Duration(seconds: 1),
                    startPadding: 10.0,
                    // accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    // decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                    style: const TextStyle(
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 15.r, right: 15.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Ionicons.newspaper_outline,
                        color: Colors.grey.shade600,
                      ),
                      const Text("Blog Terkini",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          )),
                      Expanded(child: Container()),
                      RichText(
                          text: TextSpan(
                              text: "Lihat Semua",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DetailBerita(),
                                      ));
                                },
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ))),
                    ],
                  ),
                ),
                const CarouselWidget(),
                Padding(
                  padding: EdgeInsets.only(left: 15.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Ionicons.newspaper_outline,
                        color: Colors.grey.shade600,
                      ),
                      const Text("Blog Populer",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          )),
                      Expanded(child: Container())
                    ],
                  ),
                ),
                const SliderCarouselPopuler(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
