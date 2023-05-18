import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/Animated%20Navigation/entry_point.dart';
import 'package:mobile/beranda.dart';
import 'package:mobile/login.dart';
import 'package:mobile/onSignIn/components/animated_btn.dart';
import 'package:mobile/onSignIn/components/signin_dialog.dart';
import 'package:mobile/onSignIn/components/signin_form.dart';
import 'package:mobile/perlengkapan/colors.dart';
import 'package:mobile/appbar%20profile/profile.dart';
import 'package:mobile/registrasi.dart';
import 'package:rive/rive.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Google Api/google_signin_api.dart';
import 'Google Api/model_user.dart';

class ChoiceSigninSignUp extends StatefulWidget {
  const ChoiceSigninSignUp({super.key});

  @override
  State<ChoiceSigninSignUp> createState() => _ChoiceSigninSignUpState();
}

class _ChoiceSigninSignUpState extends State<ChoiceSigninSignUp> {
  late RiveAnimationController _btnAnimationController;
  bool isShowSignUpDialog = false;
  Widget _buildThirdPartyLogin(
      String loginType, String logo, VoidCallback signIn) {
    return GestureDetector(
      onTap: () => signIn(),
      child: Container(
        width: 295.w,
        height: 44.h,
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          mainAxisAlignment:
              logo == '' ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            logo == ''
                ? Container()
                : Container(
                    padding: EdgeInsets.only(left: 30.w, right: 20.w),
                    child: Image.asset("assets/images/$logo.png"),
                  ),
            Text(
              loginType,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpWidget(final VoidCallback onTapF) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: const [
              Expanded(
                child: Divider(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Belum Punya Akun?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                  child: Divider(
                color: Colors.white,
              )),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          InkWell(
            onTap: () => onTapF(),
            child: Text(
              "Daftar Disini",
              style: TextStyle(
                  color: AppColors.primaryElement,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.underline,
                  fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildThirdPartyLogin("Login Dengan Google", "google", () {
          print('google login');
          // signInGoogle();
          // var user = await GoogleSignInApi.login();
          // if (user != null) {
          //   // ignore: use_build_context_synchronously
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => Profile(
          //           googleName: user.displayName!,
          //           googleEmail: user.email,
          //           googleImage: user.photoUrl!,
          //         ),
          //       ));
          // }
          // print("google login");
          // var user = await GoogleSignInApi.login();
          // if (user != null) {
          //   String? displayName = user.displayName;
          //   String email = user.email;
          //   // String id = user.id;
          //   String photoUrl = user.photoUrl ?? 'assets/images/logo2.png';
          //   LoginRequestEntity loginRequestEntity = LoginRequestEntity();
          //   loginRequestEntity.imageProfile = photoUrl;
          //   loginRequestEntity.name = displayName;
          //   loginRequestEntity.email = email;
          // }
        }),
        _buildThirdPartyLogin("Login Dengan Facebook", "f", () {
          print('facebook login');
        }),
        _buildThirdPartyLogin("Akun SmartWash", '', () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
        }),
        _buildSignUpWidget(
          () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistrasionPage(),
                ));
          },
        )
      ],
    );
  }

  // Future signInGoogle() async {
  //   final user = await GoogleSignInApi.login();

  //   if (user == null) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Sign In Failed')));
  //   } else {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => Profile(user: user),
  //     ));
  //   }
  // }
}
