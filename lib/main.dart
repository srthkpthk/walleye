import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_bloc.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_event.dart';
import 'package:walleye/src/data/repository/WallpaperRepository.dart';
import 'package:walleye/src/ui/wall_eye_home.dart';
import 'package:walleye/src/util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
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
      home: RepositoryProvider(
        create: (BuildContext context) => WallpaperRepository(),
        child: BlocProvider<CuratedWallpapersBloc>(
          create: (BuildContext context) => CuratedWallpapersBloc(
            context.repository<WallpaperRepository>(),
          )..add(FetchCuratedWallpapers(0)),
          child: WallEyeHome(),
        ),
      ),
    );
  }
}
