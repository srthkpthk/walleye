import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_bloc.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_event.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_state.dart';
import 'package:walleye/src/ui/wallpaper_tile.dart';

class WallEyeHome extends StatefulWidget {
  @override
  _WallEyeHomeState createState() => _WallEyeHomeState();
}

class _WallEyeHomeState extends State<WallEyeHome> {
  ScrollController _controller;
  bool shouldShowFAB = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() => _scrollListener(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = (size.width / 2);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'WallEye',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder(
        cubit: context.bloc<CuratedWallpapersBloc>(),
        builder: (BuildContext context, state) {
          if (state is CuratedWallpapersInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CuratedWallpapersFailed) {
            return Center(
              child: Text('Wallpapers are not available at this time'),
            );
          }
          if (state is CuratedWallpapersSuccess) {
            return GridView.builder(
              controller: _controller,
              itemCount: state.photos.length + 1,
              padding: EdgeInsets.all(5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: (itemWidth / itemHeight)),
              itemBuilder: (context, index) {
                if (index != state.photos.length) {
                  return WallpaperTile(
                    state.photos[index],
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          } else {
            return null;
          }
        },
      ),
      floatingActionButton: shouldShowFAB
          ? FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () => _controller.animateTo(
                0,
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
              ),
            )
          : null,
    );
  }

  _scrollListener(BuildContext context) {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      log('Getting next Page');
      int currentPageNUmber;
      var state = context.bloc<CuratedWallpapersBloc>().state;
      if (state is CuratedWallpapersSuccess) {
        currentPageNUmber = state.currentPageNumber;
      }
      context.bloc<CuratedWallpapersBloc>().add(
            FetchCuratedWallpapers(currentPageNUmber),
          );
    }
    if (_controller.offset > 1000) {
      if (!shouldShowFAB) {
        setState(
          () {
            shouldShowFAB = true;
          },
        );
      }
    } else {
      if (shouldShowFAB) {
        setState(
          () {
            shouldShowFAB = false;
          },
        );
      }
    }
  }
}
