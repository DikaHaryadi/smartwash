import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/beranda.dart';
import 'package:mobile/appbar%20profile/profile.dart';
import 'package:mobile/paket_category.dart';
import 'package:rive/rive.dart';
import 'package:mobile/perlengkapan/colors.dart';

import '../Google Api/google_signin_api.dart';
import '../search_page.dart';
import 'components/btm_nav_item.dart';
import 'components/menu.dart';
import 'components/menu_btn.dart';
import 'components/rive_utils.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({
    super.key,
    // required this.user,
  });

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  late GoogleSignInAccount user;
  Menu selectedBottonNav = bottomNavItems.first;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

// Navigation nya
  int currentPages = 0;

  List pages = [
    Beranda(),
    const SearchPage(),
    const PaketCategory(),
    Profile()
  ];

  void onTapped(int index) {
    setState(() {
      currentPages = index;
    });
  }
  // Akhir dari Navigation nya

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[currentPages],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(86, 215, 188, 10).withOpacity(0.7),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                  (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                        updateSelectedBtmNav(navBar);
                        onTapped(index);
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: navBar.rive.stateMachineName);
                      },
                      selectedNav: selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//   Future signInGoogle() async {
//     // final user = await GoogleSignInApi.login();
//     var user = await GoogleSignInApi.login();
//     // if (user == null) {
//     //   ScaffoldMessenger.of(context)
//     //       .showSnackBar(SnackBar(content: Text('Sign In Failed')));
//     // } else {
//     //   Navigator.of(context).pushReplacement(MaterialPageRoute(
//     //     builder: (context) => Profile(user: user),
//     //   ));
//     // }
//   }
}
