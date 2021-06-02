import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:walleye/src/ui/Home/wall_eye_home.dart';
import 'package:walleye/src/util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WallEye',
      theme: ThemeUtils().lightMode,
      darkTheme: ThemeUtils().darkMode,
      home: WallEyeHome(),
    );
  }
}
