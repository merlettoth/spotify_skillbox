// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

// Project imports:
import 'package:spotify_skillbox/ui/app/app.dart';
import 'package:spotify_skillbox/ui/app/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FlutterDisplayMode.setHighRefreshRate();

  runApp(
    const AppDependencies(
      app: App(),
    ),
  );
}
