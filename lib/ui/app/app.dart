// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:spotify_skillbox/ui/home/home_widget.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Skillbox',
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorConstants.blackMatte,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorConstants.primary,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          backgroundColor: ColorConstants.deepBlack,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.31,
          ),
          toolbarHeight: 83,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: ColorConstants.primary,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomeWidget(),
    );
  }
}
