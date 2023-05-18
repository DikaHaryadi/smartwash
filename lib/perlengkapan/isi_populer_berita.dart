import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/perlengkapan/skelton.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IsiBeritaPopuler extends StatefulWidget {
  final int idBerita;

  const IsiBeritaPopuler({required this.idBerita});

  @override
  State<IsiBeritaPopuler> createState() => _IsiBeritaState();
}

class _IsiBeritaState extends State<IsiBeritaPopuler> {
  late String id = widget.idBerita.toString();
  var beritaIsi;
  Future getData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/isi-populer?id=$id'));

      if (response.statusCode == 200) {
        var isi = json.decode(response.body);
        setState(() {
          print(isi);
          beritaIsi = isi ?? '';
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Color.fromRGBO(86, 215, 188, 10).withOpacity(0.8),
            title: beritaIsi == null
                ? null
                : Text(
                    beritaIsi['data'][0]['title'] ?? '',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis),
                  ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              beritaIsi == null
                  ? Skelton(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 15,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        beritaIsi['data'][0]['title'] ?? '',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            // color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
              beritaIsi == null
                  ? Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Skelton(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.height / 25,
                          ),
                          Skelton(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 25,
                          )
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        beritaIsi['data'][0]['role'] == null
                            ? Container(
                                color: Colors.transparent,
                              )
                            : Container(
                                height: 25.h,
                                margin: EdgeInsets.only(left: 10.w),
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
                                    beritaIsi['data'][0]['role'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            dateTime.format(DateTime.parse(
                                beritaIsi['data'][0]['tanggal'] ?? '')),
                            style: GoogleFonts.poppins(
                                // color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
              beritaIsi == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Skelton(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        fit: BoxFit.cover,
                        imageUrl:
                            'http://10.0.2.2:8000/uploads/${beritaIsi['data'][0]['image']}',
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
              beritaIsi == null
                  ? Skelton(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 5)
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Text(
                        beritaIsi['data'][0]['isiberita'],
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                            // color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
              // beritaIsi == null
              //     ? Padding(
              //         padding: const EdgeInsets.only(top: 10.0),
              //         child: Skelton(
              //             width: MediaQuery.of(context).size.width,
              //             height: MediaQuery.of(context).size.height / 4),
              //       )
              //     : Padding(
              //         padding:
              //             const EdgeInsets.only(left: 10, right: 10, top: 10),
              //         child: Text(
              //           beritaIsi['data'][0]['subisi'],
              //           textAlign: TextAlign.justify,
              //           style: GoogleFonts.poppins(
              //               // color: Colors.black,
              //               fontSize: 12,
              //               fontWeight: FontWeight.normal),
              //         ),
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
