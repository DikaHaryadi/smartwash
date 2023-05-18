import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromosiCarousel extends StatefulWidget {
  const PromosiCarousel({super.key});

  @override
  State<PromosiCarousel> createState() => _PromosiCarouselState();
}

class _PromosiCarouselState extends State<PromosiCarousel> {
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

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        for (var i = 0; i < listItem.length; i++)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height / 3,
              fit: BoxFit.contain,
              imageUrl: 'http://10.0.2.2:8000/uploads/${listItem[i]['img']}',
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
      ],
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 0.95,
        enlargeCenterPage: true,
      ),
    );
  }
}
