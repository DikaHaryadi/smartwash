import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/login.dart';
import 'package:mobile/main.dart';
import 'package:mobile/onSignIn/components/animated_btn.dart';
import 'package:mobile/onSignIn/components/signin_form.dart';
import 'package:mobile/perlengkapan/colors.dart';
import 'package:mobile/perlengkapan/image_controller.dart';
import 'package:rive/rive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';

class RegistrasionPage extends StatefulWidget {
  const RegistrasionPage({super.key});

  @override
  State<RegistrasionPage> createState() => _RegistrasiSectionState();
}

class _RegistrasiSectionState extends State<RegistrasionPage> {
  // late RiveAnimationController _btnAnimationController;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late String errormsg;
  late SMITrigger confetti;

  // late String errormsg;
  late bool showprogress;
  bool? _passwordVisible = true;

  @override
  void initState() {
    errormsg = "";
    // error = false;
    showprogress = false;
    _passwordVisible = true;
    super.initState();
  }

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  Future<void> _registration(BuildContext context) async {
    String apiurl = "http://10.0.2.2:8000/api/register";

    var response = await http.post(Uri.parse(apiurl), body: {
      'email': emailController.text, //get the username text
      'password': passwordController.text, //get password text
      'name': nameController.text
    });
    // final uri = Uri.parse(apiurl);
    // var request = http.MultipartRequest('POST', uri);
    // request.fields['email'] = emailController.text;
    // request.fields['password'] = passwordController.text;
    // request.fields['name'] = nameController.text;
    // request.fields['image_profile'] = _imagename;

    // var pic = await http.MultipartFile.fromPath('image_profile', image!.path);
    // request.files.add(pic);
    // var streamResponse = await request.send();
    // var response = await http.Response.fromStream(streamResponse);
    // print(_imagename);
    print('before');
    // if (response.statusCode == 200) {
    var jsondata = json.decode(response.body);
    print(jsondata[0]["msg"] + ' a');

    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
      showprogress = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (jsondata[0]["success"] == true) {
          success.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowConfetti = false;
                isShowLoading = false;
                showprogress = false;
              });
              confetti.fire();
              Future.delayed(const Duration(seconds: 1), () {
                // Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              });
            },
          );
          //toast
          print('benar');
        } else {
          print('salah');
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false; //don't show progress indicator
                // error = true;
                showprogress = false;
                errormsg = jsondata[0]["msg"];
              });
              reset.fire();
            },
          );
          showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: "Sign",
            context: context,
            transitionDuration: const Duration(milliseconds: 400),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              Tween<Offset> tween;
              tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
              return SlideTransition(
                position: tween.animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              );
            },
            pageBuilder: (context, _, __) => Center(
              child: Container(
                height: 185.h,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground.withOpacity(0.94),
                  image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/doodle.png")),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Mohon Maaf",
                              style: TextStyle(
                                  fontSize: 34, fontFamily: "Poppins"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                jsondata[0]['msg'],
                                style: const TextStyle(
                                    fontSize: 24, fontFamily: "Intel"),
                              ),
                            ),
                            const Text(
                              "silahkan coba email yang berbeda",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 24, fontFamily: "Intel"),
                            )
                          ],
                        ),
                      ),
                      const Positioned(
                          left: 0,
                          right: 0,
                          bottom: -70,
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
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Get.lazyPut(() => ImageController());

    return Scaffold(body: GetBuilder<ImageController>(
      builder: (imageController) {
        return SafeArea(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Stack(
                children: [
                  Column(children: [
                    // app logo is here
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/logo2.png"))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.r),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello!",
                            style: TextStyle(
                              fontSize: 20 * 2 + 20 / 5.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Buat akun baru",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.grey[500],
                                fontFamily: "Intel"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // your name
                    Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            // photo profile
                            // const Text('Photo'),
                            // GestureDetector(
                            //   onTap: () => imageController.pickImage(),
                            //   child: Container(
                            //     height: 30.h,
                            //     width: 100.h,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10.r),
                            //         color: AppColors.primaryColor
                            //             .withOpacity(0.8)),
                            //     child: const Text('Select Image'),
                            //   ),
                            // ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   width: double.infinity,
                            //   height: 200.h,
                            //   color: Colors.grey,
                            //   child: imageController.pickedFile != null
                            //       ? Image.file(
                            //           File(imageController.pickedFile!.path),
                            //           width: 100.w,
                            //           height: 100.h,
                            //           fit: BoxFit.cover,
                            //         )
                            //       : const Text('PLEASE SELECT an IMAGE'),
                            // ),

                            // GestureDetector(
                            //   onTap: () => Get.find<ImageController>().upload(),
                            //   child: Container(
                            //     height: 30.h,
                            //     width: 100.h,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10.r),
                            //         color: AppColors.primaryColor
                            //             .withOpacity(0.8)),
                            //     child: const Text('Server upload Image'),
                            //   ),
                            // ),
                            // Container(
                            //     alignment: Alignment.center,
                            //     width: double.infinity,
                            //     height: 180.h,
                            //     color: Colors.grey,
                            //     child: imageController.imagePath != null
                            //         ? Image.network(
                            //             'http://10.0.2.2:8000${imageController.imagePath!}',
                            //             width: 100.w,
                            //             height: 100.h,
                            //             fit: BoxFit.cover,
                            //           )
                            //         : const Text('PLEASE SELECT an IMAGE')),
                            // baru
                            Center(
                              child: GestureDetector(
                                child: const Text('Select and Image'),
                                // onPressed: _openImagePicker,
                                onTap: () => imageController.pickImage(),
                              ),
                            ),

                            TextFormField(
                              controller: nameController,
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                // hintText
                                hintText: 'Nama Anda',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(105, 108, 121, 0.7),
                                ),
                              ),
                              validator: (value) {
                                if (value!.length > 21 ||
                                    value.isEmpty ||
                                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                  return "Nama Hanya Diisi Huruf & Tidak Boleh Lebih Dari 21 Characters";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10.h),
                            // your email
                            TextFormField(
                              controller: emailController,
                              // style: const TextStyle(
                              //     color: AppColors.primaryText, fontSize: 16),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color.fromRGBO(105, 108, 121, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(74, 77, 84, 0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                // hintText
                                hintText: 'Example@Email.com',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(105, 108, 121, 0.7),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                                        .hasMatch(value)) {
                                  return "Harap Masukan Email Dengan Benar";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10.h),
                            // your password
                            TextFormField(
                              // style: const TextStyle(
                              //     color: AppColors.primaryText, fontSize: 16),
                              controller: passwordController,
                              obscureText: _passwordVisible!,
                              validator: (value) {
                                if (value == null || value.length < 8) {
                                  return "password minimal 8 characters";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible!
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    // color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible =
                                          _passwordVisible == true
                                              ? false
                                              : true;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromRGBO(105, 108, 121, 1),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(74, 77, 84, 0.2),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: 'Enter Password',
                                hintStyle: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(105, 108, 121, 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(right: 15.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    )),
                              text: "Login?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 15.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30 * 2.r),
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                // ini ngecek data apakah sesuai dengan yg di registrasi tadi
                                // ini buat ngecek apakah tidak ada number dll
                                showprogress = true;
                                _registration(context);
                              }
                            },
                            child: showprogress
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: SizedBox(
                                      height: 35.h,
                                      width: 35.w,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.orange[100],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.deepOrangeAccent),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 50.w,
                                    height: 50.h,
                                    margin: EdgeInsets.only(right: 15.r),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          const Color.fromRGBO(86, 215, 188, 10)
                                              .withOpacity(0.8),
                                    ),
                                    child: const Icon(
                                      Icons.keyboard_double_arrow_right_sharp,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  isShowLoading
                      ? CustomPositioned(
                          child: RiveAnimation.asset(
                            'assets/RiveAssets/check.riv',
                            fit: BoxFit.cover,
                            onInit: _onCheckRiveInit,
                          ),
                        )
                      : const SizedBox(),
                  isShowConfetti
                      ? CustomPositioned(
                          scale: 6,
                          child: RiveAnimation.asset(
                            "assets/RiveAssets/confetti.riv",
                            onInit: _onConfettiRiveInit,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(),
                ],
              )),
        );
      },
    ));
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    return ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(56.h),
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.3),
            textStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
            )),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black),
            const SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ));
  }
}
