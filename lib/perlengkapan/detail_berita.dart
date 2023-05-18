import 'dart:convert';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/perlengkapan/berita_populer.dart';
import 'package:mobile/perlengkapan/berita_terkini.dart';
import 'package:mobile/perlengkapan/themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../appbar profile/appbar_widget.dart';

class DetailBerita extends StatefulWidget {
  const DetailBerita({super.key});

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    // buat controller TabBar
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            backgroundColor:
                const Color.fromRGBO(86, 215, 188, 10).withOpacity(0.8),
            title: Text("Detail Berita",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold)),
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
            centerTitle: true,
            bottom: TabBar(
              controller: controller,
              tabs: const [
                Tab(
                  text: "Berita Terkini",
                ),
                Tab(
                  text: "Berita Populer",
                ),
              ],
              // labelColor: Colors.black,
            ),
          )
        ],
        body: TabBarView(
            viewportFraction: 1.0,
            controller: controller,
            children: const [BeritaTerkini(), BeritaPopuler()]),
      ),
    );
  }
}
