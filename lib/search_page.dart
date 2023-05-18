import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final double _offset = 0.0;

  bool search = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                offset: _offset,
                name: 'Berita Terkini',
              ),
              SizedBox(
                height: 100.h,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 10.r),
                      width: 100.w,
                      height: 50.h,
                      color: Colors.blue,
                    );
                  },
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              CustomTextField(offset: _offset, name: 'Berita Populer'),
              SizedBox(
                height: 100.h,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 10.r),
                      width: 100.w,
                      height: 50.h,
                      color: Colors.blue,
                    );
                  },
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              CustomTextField(
                offset: _offset,
                name: 'Category',
              ),
              SizedBox(
                height: 100.h,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 10.r),
                      width: 100.w,
                      height: 50.h,
                      color: Colors.blue,
                    );
                  },
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final double offset;
  final String name;
  const CustomTextField({super.key, required this.offset, required this.name});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool search = false;

  Widget change(double width) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: 10,
      left: 10,
      bottom: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 100.h,
        width: widget.offset > 30
            ? search
                ? width
                : 20
            : width,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: search
              ? TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(.2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search = true;
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 50.h,
      width: width,
      child: Stack(
        children: [
          change(width * .85),
          Positioned(
              top: 13.h,
              right: 10.w,
              child: search
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          search = false;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey.shade600,
                          )),
                    )
                  : Text(
                      widget.name,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          color: Colors.grey.shade600),
                    )),
        ],
      ),
    );
  }
}
