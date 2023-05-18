import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile/Google%20Api/google_signin_api.dart';
import '../perlengkapan/themes.dart';

SliverAppBar buildAppBar(BuildContext context) {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: Icon(Ionicons.power_outline),
      onPressed: () async {
        GoogleSignInApi.logout();
        Navigator.pop(context);
      },
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ThemeSwitcher(
          builder: (context) {
            bool isDarkMode =
                ThemeModelInheritedNotifier.of(context).theme.brightness ==
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
  );
}
