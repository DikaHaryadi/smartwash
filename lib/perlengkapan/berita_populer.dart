import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/perlengkapan/isi_populer_berita.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeritaPopuler extends StatefulWidget {
  const BeritaPopuler({super.key});

  @override
  State<BeritaPopuler> createState() => _BeritaPopulerState();
}

class _BeritaPopulerState extends State<BeritaPopuler> {
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
    return Scaffold(
      // backgroundColor: Colors.white,
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: listItem.length,
        itemBuilder: (context, index) {
          return GestureDetector(
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
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 6,
                  color: Colors.transparent,
                ),
                Positioned(
                  left: 10.0,
                  top: 10.0,
                  bottom: 20.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 6,
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
                    left: 10.w,
                    child: Row(
                      children: [
                        listItem[index]['role'] == null
                            ? Container(
                                color: Colors.transparent,
                              )
                            : Container(
                                height: 30,
                                margin: EdgeInsets.only(right: 15, top: 10),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(86, 215, 188, 10)
                                      .withOpacity(0.8),
                                  // borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    listItem[index]['role'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                      ],
                    )),
                Positioned(
                    right: 8.w,
                    top: 5.h,
                    left: 200.w,
                    child: Text(
                      listItem[index]['title'],
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          // color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),
                Positioned(
                    right: 8.w,
                    top: 50.h,
                    left: 200.w,
                    // bottom: 20.0,
                    child: Text(
                      listItem[index]['isiberita'],
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      style: GoogleFonts.poppins(
                          // color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
