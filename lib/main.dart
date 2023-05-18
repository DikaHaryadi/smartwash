import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:mobile/appbar%20profile/edit_profile_page.dart';
import 'package:mobile/beranda.dart';
import 'package:mobile/detail_promo.dart';
import 'package:mobile/login.dart';
import 'package:mobile/perlengkapan/berita_terkini.dart';
import 'package:mobile/perlengkapan/carousel_slider.dart';
import 'package:mobile/perlengkapan/detail_berita.dart';
import 'package:mobile/onSignIn/splash_page.dart';
import 'package:mobile/appbar%20profile/profile.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/perlengkapan/themes.dart';
import 'package:mobile/registrasi.dart';
import 'package:mobile/search_page.dart';

import 'Animated Navigation/entry_point.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = await ThemeService.instance;
  var initTheme = themeService.initial;
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(MyApp(theme: initTheme)));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ThemeProvider(
          initTheme: theme,
          builder: (_, theme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: child,
              theme: theme,
            );
          },
        );
      },
      child: const SplashScreen(),
    );
  }
}
