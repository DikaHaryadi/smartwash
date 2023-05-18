import 'dart:convert';
import 'dart:math';
import 'package:mobile/Animated%20Navigation/entry_point.dart';
import 'package:mobile/choice_singin_signup.dart';
import 'package:mobile/onSignIn/components/signin_form.dart';
import 'package:mobile/onSignIn/splash_page.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:mobile/beranda.dart';
import 'package:mobile/main.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/perlengkapan/colors.dart';
import 'package:mobile/registrasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _prefs = SharedPreferences.getInstance();

  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error2;
  late SMITrigger success;
  late SMITrigger reset;
  late String errormsg;
  late SMITrigger confetti;

  late bool error, showprogress;
  bool? _passwordVisible = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    errormsg = "";
    error = false;
    showprogress = false;
    _passwordVisible = true;
    //_username.text = "defaulttext";
    //_password.text = "defaultpassword";
    super.initState();
  }

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error2 = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  startLogin() async {
    final SharedPreferences prefs = await _prefs;
    String apiurl = "http://10.0.2.2:8000/api/login";

    var response = await http.post(Uri.parse(apiurl), body: {
      'email': emailController.text, //get the username text
      'password': passwordController.text //get password text
    });
    // print(_email.text);
    print(response.body);

    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
      showprogress = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata["success"] == false) {
            error2.fire();
            print("salah");
            Future.delayed(
              const Duration(seconds: 2),
              () {
                setState(() {
                  isShowLoading = false;
                  showprogress = false; //don't show progress indicator
                  // error = true;
                  errormsg = jsondata["msg"];
                });
                reset.fire();
              },
            );
            showGeneralDialog(
              barrierDismissible: true,
              barrierLabel: "Sign",
              context: context,
              transitionDuration: const Duration(milliseconds: 400),
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                Tween<Offset> tween;
                tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 30),
                        blurRadius: 60,
                      ),
                      const BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 30),
                        blurRadius: 60,
                      ),
                    ],
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 295.w,
                                height: 44.h,
                                padding: EdgeInsets.all(10.h),
                                margin: EdgeInsets.only(bottom: 15.h),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryBackground,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1))
                                    ]),
                                child: const Center(
                                  child: Text(
                                    "Mohon Maaf",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "Poppins",
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                width: 295.w,
                                height: 44.h,
                                padding: EdgeInsets.all(10.h),
                                margin: EdgeInsets.only(bottom: 15.h),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryBackground,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: const Offset(0, 1))
                                    ]),
                                child: Center(
                                  child: Text(
                                    errormsg,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Intel",
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: -70,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey.shade400,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            if (jsondata["success"] == true) {
              print("benar");
              success.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowConfetti = false;
                    isShowLoading = false;
                    error = false;
                    showprogress = false;
                  });
                  confetti.fire();
                  Future.delayed(
                    const Duration(seconds: 1),
                    () async {
                      await prefs.setString(
                          'name', jsondata['data'][0]["nama_user"]);
                      await prefs.setString(
                          'email', jsondata['data'][0]["email"]);
                      // await prefs.setString('image_profile',
                      //     jsondata['data'][0]['image_profile'] ?? '');

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EntryPoint()),
                      );
                    },
                  );
                },
              );
              // print(jsondata['data'][0]["profileImage"]);
            } else {
              setState(() {
                showprogress = false; //don't show progress indicator
                error = true;
              });
            }
          }
        } else {
          error2.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
                showprogress = false; //don't show progress indicator
                error = true;
                errormsg = "Jaringan Internet Bermasalah";
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
              tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 30),
                      blurRadius: 60,
                    ),
                    const BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 30),
                      blurRadius: 60,
                    ),
                  ],
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 295.w,
                              height: 44.h,
                              margin: EdgeInsets.only(bottom: 15.h),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryBackground,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: const Center(
                                child: Text(
                                  "Mohon Maaf",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: "Poppins",
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              width: 295.w,
                              height: 44.h,
                              padding: EdgeInsets.all(10.h),
                              margin: EdgeInsets.only(bottom: 15.h),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryBackground,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: Center(
                                child: Text(
                                  errormsg,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Intel",
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: -70,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey.shade400,
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

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/logo2.png"))),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The Cleaning Fairy",
                          style: TextStyle(
                              fontSize: 30.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Universitas Darma Persada',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: "Intel",
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            // your email
                            TextFormField(
                              // style: const TextStyle(
                              //     color: AppColors.primaryText, fontSize: 16),
                              controller: emailController,
                              decoration: const InputDecoration(
                                  // hintText
                                  hintText: "Masukin Email Anda",
                                  hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color:
                                          Color.fromRGBO(105, 108, 121, 0.7)),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
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
                                  ))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email Tidak Boleh Kosong";
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
                                if (value == null || value.isEmpty) {
                                  return "Password Tidak Boleh Kosong";
                                }
                                return null;
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
                                    color: Colors.red,
                                  ),
                                ),
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(105, 108, 121, 0.7),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0).r,
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SplashScreen(),
                                  ));
                            },
                            child: Text(
                              "Back?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 15.sp),
                            )),
                        Expanded(child: Container()),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrasionPage(),
                                  ));
                            },
                            child: Text(
                              "Belum Punya Akun?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 15.sp),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30 * 2),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          child: showprogress
                              ? Container(
                                  margin:
                                      EdgeInsets.only(right: 15.r, top: 5.r),
                                  height: 35.h,
                                  width: 35.w,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.orange[100],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.deepOrangeAccent),
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
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                showprogress = true;
                                startLogin();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          ),
        ),
      ),
    );
  }
}
