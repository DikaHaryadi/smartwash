import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/appbar%20profile/profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'appbar_widget.dart';
import 'textfield_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EditProfilePage extends StatelessWidget {
  final String googleName;
  final String googleEmail;
  final String googleImage;
  const EditProfilePage(
      {super.key,
      required this.googleName,
      required this.googleEmail,
      required this.googleImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        buildAppBar(context),
      ],
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: googleImage,
            isEdit: true,
            onCliked: () async {
              // final image =
              //     await ImagePicker().getImage(source: ImageSource.gallery);

              // if (image == null) return;

              // final directory = await getApplicationDocumentsDirectory();
              // final name = basename(image.path);
              // final imageFile = File('${directory.path}/$name');
              // final newImage = await File(image.path).copy(imageFile.path);

              // setState(() => user = user.copy(imagePath: newImage.path));
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          TextFieldWidget(
            label: 'Nama',
            text: googleName,
            onChanged: (nama) {},
          ),
          SizedBox(
            height: 5.h,
          ),
          TextFieldWidget(
            label: 'Email',
            text: googleEmail,
            onChanged: (nama) {},
          )
        ],
      ),
    ));
  }
}

// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // String nama = '';
  // String email = '';
  // String image_profile = '';
  // File? image;

  // Future<void> getUSerData() async {
  //   final SharedPreferences prefs = await _prefs;
  //   setState(() {
  //     nama = prefs.getString('name') ?? '';
  //     email = prefs.getString('email') ?? '';
  //     image_profile = prefs.getString('image_profile') ?? '';
  //   });
  // }

  // void initState() {
  //   super.initState();
  //   getUSerData().then((_) {
  //     getUSerData();
  //   });
  // }

  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;

  //     final imageTemporary = File(image.path);
  //     setState(() {
  //       this.image = imageTemporary;
  //     });
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }