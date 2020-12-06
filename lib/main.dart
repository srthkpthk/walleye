import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:walleye/src/data/model/photoEntity/src.dart';
import 'package:walleye/src/ui/Home/wall_eye_home.dart';
import 'package:walleye/src/util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Hive.initFlutter();
  Hive.registerAdapter(
    PhotosAdapter(),
  );
  Hive.registerAdapter(
    SrcAdapter(),
  );
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
