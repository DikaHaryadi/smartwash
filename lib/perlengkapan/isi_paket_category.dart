import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile/perlengkapan/colors.dart';
import 'package:mobile/perlengkapan/skelton.dart';
import '../Animated Navigation/entry_point.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee/marquee.dart';
import 'package:dropdown_plus/dropdown_plus.dart';

class IsiPaketCategory extends StatefulWidget {
  final int idBerita;
  final int harga;
  final String isiPaket;
  const IsiPaketCategory(
      {super.key,
      required this.idBerita,
      required this.harga,
      required this.isiPaket});

  @override
  State<IsiPaketCategory> createState() => _IsiPaketCategoryState();
}

class _IsiPaketCategoryState extends State<IsiPaketCategory> {
  final _prefs = SharedPreferences.getInstance();
  String name = '';
  _getUserData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  var paketCategory;
  late String id = widget.idBerita.toString();
  late int harga = widget.harga;
  late String isiPaket = widget.isiPaket;

  late bool showprogress;
  late int subTotal;
  late int banyakpesanan = 0;
  late bool aktif;

  final formKey = GlobalKey<FormState>();

  var _nama = TextEditingController();
  // var _jenispesanan = TextEditingController();
  var _telepon = TextEditingController();
  var _alamat = TextEditingController();
  var _catatan = TextEditingController();
  var _banyakpesanan = TextEditingController();
  var _subTotal = TextEditingController();

  var _jenisKelamin = '';
  var _jenisPesanan = '';
  Future getData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/isi-paket?id=$id'));

      if (response.statusCode == 200) {
        var isi = json.decode(response.body);
        setState(() {
          print(isi);
          paketCategory = isi ?? '';
        });
      } else {
        print("Ada Yang Salah");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  postBerita() async {
    String apiurl = "http://10.0.2.2:8000/api/berita"; //api url

    // var response = await http.post(Uri.parse(apiurl), body: {
    //   'nama': _nama.text, //get the username text
    //   // 'gender': _gender.text,
    //   'jenispesanan': _jenispesanan.text,
    //   'telepon': _telepon.text,
    //   'alamat': _alamat.text, //get the username text
    //   'catatan': _catatan.text,
    //   //get password text
    // });

    final uri = Uri.parse(apiurl);
    var request = http.MultipartRequest('POST', uri);
    request.fields['nama'] = _nama.text;
    request.fields['gender'] = _jenisKelamin;
    request.fields['jenispesanan'] = isiPaket;
    request.fields['harga'] = widget.harga.toString();
    request.fields['banyak_pesanan'] = _banyakpesanan.text;
    request.fields['total_harga'] = _subTotal.text;
    request.fields['telepon'] = _telepon.text;
    request.fields['alamat'] = _alamat.text;
    request.fields['catatan'] = _catatan.text;
    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    print(response.body);
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["data"] == true) {
        setState(() {
          showprogress = false;
        });
        //toast

        const snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: Text('Selamat Pemesanan Berhasil'),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // ignore: use_build_context_synchronously

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EntryPoint()),
        );
        print('berhasil');
      } else {
        setState(() {
          showprogress = false; //don't show progress indicator

          // errormsg = jsondata["message"];
        });
        // errormsg = "Something went wrong.";

        const snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: Text('Harap Masukan Data Dengan Benar!'),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // ignore: use_build_context_synchronously
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        print("Error during conncecting to server");
        // errormsg = "Error during connecting to server.";
      });
    }
  }

  @override
  void initState() {
    getData();
    _getUserData().then((_) {
      _getUserData();
    });
    showprogress = false;
    subTotal = 0;
    aktif = false;
    super.initState();
  }

  final formater =
      NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color.fromRGBO(86, 215, 188, 10).withOpacity(0.8),
        title: paketCategory == null
            ? null
            : Text(
                isiPaket,
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            paketCategory == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Skelton(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Text(
                      paketCategory['data'][0]['title'] ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
            paketCategory == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Skelton(
                      width: MediaQuery.of(context).size.width / 1.9,
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0),
                    child: Text(
                      paketCategory['data'][0]['deskripsi'] ?? '',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                paketCategory == null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Skelton(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height / 25),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          formater.format(double.parse(paketCategory['data'][0]
                                  ['harga'] ??
                              'Biaya Belum Dimasukan')),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 15,
              color: const Color.fromRGBO(86, 215, 188, 10).withOpacity(0.8),
              child: Marquee(
                text: "Hallo $name silahkan pesan di bawah ini yaa ^_^.",
                blankSpace: 20.0,
                velocity: 50.0, //speed
                // pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                // accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                // decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Lengkap',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _nama,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromRGBO(105, 108, 121, 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(74, 77, 84, 0.2),
                          ),
                        ),
                        hintText: 'Nama Lengkap',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(105, 108, 121, 0.7),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "*Nama Hanya Diisi Huruf";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Jenis Kelamin',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextDropdownFormField(
                      options: ["Laki-Laki", "Perempuan"],
                      onChanged: (dynamic str) {
                        print(str.toString());
                        setState(() {
                          _jenisKelamin = str.toString();
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(74, 77, 84, 0.2),
                          ),
                        ),
                        prefixIcon: Icon(FontAwesomeIcons.genderless),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      dropdownHeight: 120,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Nomer Telepon',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _telepon,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          LineIcons.identificationBadge,
                          color: Color.fromRGBO(105, 108, 121, 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(74, 77, 84, 0.2),
                          ),
                        ),
                        hintText: 'No Telepon',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(105, 108, 121, 0.7),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                                .hasMatch(value)) {
                          return "*Nomer Telpon Tidak Boleh Kosong";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Alamat',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _alamat,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          LineIcons.addressCard,
                          color: Color.fromRGBO(105, 108, 121, 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(74, 77, 84, 0.2),
                          ),
                        ),
                        hintText: 'Alamat',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(105, 108, 121, 0.7),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Alamat Tidak Boleh Kosong";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Jenis Pesanan :',
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      isiPaket,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Banyak Pesanan",
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              banyakpesanan > 0 ? banyakpesanan-- : 0;
                              // banyakpesanan = banyakpesanan - 1;
                              _banyakpesanan.text = banyakpesanan.toString();
                              subTotal = harga * banyakpesanan;
                              _subTotal.text = formater
                                  .format(double.parse(subTotal.toString()));
                            });
                          },
                          child: Icon(
                            Ionicons.remove_circle,
                            size: 30.h,
                            color: aktif == false
                                ? Colors.grey
                                : Colors.orangeAccent,
                          ),
                        ),
                        Container(
                          width: 60.h,
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            onChanged: (value) {
                              subTotal = harga * int.parse(value);
                              _subTotal.text = formater
                                  .format(double.parse(subTotal.toString()));
                            },
                            textAlign: TextAlign.center,
                            controller: _banyakpesanan,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: const Color.fromRGBO(105, 108, 121, 0.7),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              banyakpesanan++;
                              _banyakpesanan.text = banyakpesanan.toString();
                              subTotal = harga * banyakpesanan;
                              _subTotal.text = formater
                                  .format(double.parse(subTotal.toString()));
                            });
                          },
                          child: Icon(
                            Ionicons.add_circle,
                            size: 30.h,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        // Text(
                        //   satuan == '' ? '' : satuan,
                        //   style: GoogleFonts.poppins(
                        //       fontSize: 14.sp, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _subTotal,
                      enabled: false,
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefix: Icon(Ionicons.pricetags_outline),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(74, 77, 84, 0.2),
                          ),
                        ),
                        hintText: '*Total Harga Pemesanan',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(105, 108, 121, 0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Catatan Pemesanan',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _catatan,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          LineIcons.infoCircle,
                          color: Color.fromRGBO(105, 108, 121, 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(74, 77, 84, 0.2),
                          ),
                        ),
                        hintText: 'Catatan',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(105, 108, 121, 0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 35,
                    ),
                  ],
                ),
              ),
            ),
            paketCategory == null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Skelton(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        //show progress indicator on click
                        showprogress = true;
                      });
                      if (formKey.currentState!.validate()) {
                        postBerita();
                        setState(() {
                          // show proggress indicator on click
                          showprogress = true;
                        });
                      } else {
                        setState(() {
                          showprogress = false;
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 20,
                      margin: const EdgeInsets.only(
                          right: 10, left: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(86, 215, 188, 10)
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: showprogress
                            ? SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.orange[100],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.deepPurpleAccent),
                                ),
                              )
                            : Text(
                                "Mulai Booking",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
