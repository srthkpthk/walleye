import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_bloc.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_event.dart';
import 'package:walleye/src/data/repository/WallpaperRepository.dart';
import 'package:walleye/src/ui/curated_wallpaer_home.dart';

class WallEyeHome extends StatefulWidget {
  @override
  _WallEyeHomeState createState() => _WallEyeHomeState();
}

class _WallEyeHomeState extends State<WallEyeHome> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    RepositoryProvider(
      create: (BuildContext context) => WallpaperRepository(),
      child: BlocProvider<CuratedWallpapersBloc>(
        create: (BuildContext context) => CuratedWallpapersBloc(
          context.repository<WallpaperRepository>(),
        )..add(FetchCuratedWallpapers(0)),
        child: CuratedWallpaperScreen(),
      ),
    ),
    Text('Search'),
    Text('Categories Screen'),
    Text('Favourites Screen'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'WallEye',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    backgroundColor: Colors.grey,
                    text: 'Curated',
                  ),
                  GButton(
                    icon: LineIcons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: LineIcons.calendar,
                    text: 'Categories',
                  ),
                  GButton(
                    icon: LineIcons.heart_o,
                    text: 'Favourites',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
