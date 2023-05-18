import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile/appbar%20profile/edit_profile_page.dart';
import 'package:mobile/login.dart';
import 'package:mobile/perlengkapan/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Google Api/google_signin_api.dart';
import '../perlengkapan/themes.dart';
import 'appbar_widget.dart';
import 'profile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String nama = '';
  String email = '';
  String image_profile = '';
  _logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear(); // <- remove sharedpreferences

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    ); // <- navigasi ke login
  }

  Future<void> getUSerData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      nama = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      // image_profile = prefs.getString('image') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getUSerData().then((_) {
      getUSerData();
    });
  }

  TextStyle headingStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 43, 110, 100));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Ionicons.power_outline,
              color: Colors.grey,
            ),
            onPressed: () {
              _logout();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ThemeSwitcher(
                builder: (context) {
                  bool isDarkMode = ThemeModelInheritedNotifier.of(context)
                          .theme
                          .brightness ==
                      Brightness.light;
                  String themeName = isDarkMode ? 'dark' : 'light';
                  return DayNightSwitcherIcon(
                    isDarkModeEnabled: isDarkMode,
                    onStateChanged: (bool darkMode) async {
                      var service = await ThemeService.instance
                        ..save(darkMode ? 'light' : 'dark');
                      var theme = service.getByName(themeName);
                      // ignore: use_build_context_synchronously
                      ThemeSwitcher.of(context)
                          .changeTheme(theme: theme, isReversed: darkMode);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: image_profile,
              onCliked: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    googleImage:
                        'https://th.bing.com/th/id/OIP.zk9KX_SpM6A9Jn2NRFg8egHaJz?pid=ImgDet&rs=1',
                    googleEmail: email,
                    googleName: nama,
                  ),
                ));
              },
            ),
            const SizedBox(
              height: 24,
            ),
            buildName(nama, email)
          ],
        ));
  }

  Widget buildName(String name, email) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 16.sp),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          email,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.normal,
              color: Colors.grey,
              fontSize: 12.sp),
        ),
      ],
    );
  }
}

// class Profile extends StatelessWidget {
//   final String googleName;
//   final String googleEmail;
//   final String googleImage;
//   Profile({
//     super.key,
//     required this.googleName,
//     required this.googleEmail,
//     required this.googleImage,
//   });

//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   // String nama = '';
//   TextStyle headingStyle = const TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.w600,
//       color: Color.fromARGB(255, 43, 110, 100));

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // backgroundColor: AppColors.primaryBackground,
//         body: SafeArea(
//       child: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           buildAppBar(context),
//         ],
//         body: ListView(
//           physics: const BouncingScrollPhysics(),
//           children: [
//             ProfileWidget(
//               imagePath: googleImage,
//               onCliked: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => EditProfilePage(
//                     googleImage: googleImage,
//                     googleEmail: googleEmail,
//                     googleName: googleName,
//                   ),
//                 ));
//               },
//             ),

//             // CircleAvatar(
//             //   radius: 30.r,
//             //   backgroundImage: NetworkImage(googleImage),
//             // ),
//             const SizedBox(
//               height: 24,
//             ),
//             buildName(googleName, googleEmail)
//           ],
//         ),
//       ),
//     ));
//   }

//   Widget buildName(String name, email) {
//     return Column(
//       children: [
//         Text(
//           name,
//           style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w400,
//               fontSize: 16.sp),
//         ),
//         const SizedBox(
//           height: 4,
//         ),
//         Text(
//           email,
//           style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.normal,
//               color: Colors.grey,
//               fontSize: 12.sp),
//         ),
//       ],
//     );
//   }
// }
