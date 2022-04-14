// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/ui/home/home_widget_model.dart';
import 'package:spotify_skillbox/ui/home/navigators/artists_navigator.dart';
import 'package:spotify_skillbox/ui/home/navigators/collection_navigator.dart';
import 'package:spotify_skillbox/ui/home/navigators/search_navigator.dart';
import 'package:spotify_skillbox/ui/home/widgets/bottom_navigation_bar_widget.dart';
import 'package:spotify_skillbox/ui/home/widgets/player_bar.dart';
import 'package:spotify_skillbox/utils/enums.dart';

class HomeWidget extends ElementaryWidget<IHomeWidgetModel> {
  const HomeWidget({
    Key? key,
    WidgetModelFactory wmFactory = homeWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IHomeWidgetModel wm) {
    return ValueListenableBuilder<TypePage>(
      valueListenable: wm.currentPage,
      builder: (_, currentPage, __) {
        return WillPopScope(
          onWillPop: wm.onWillPop,
          child: Scaffold(
            key: wm.scaffoldKey,
            bottomNavigationBar: BottomNavigationBarWidget(
              currentIndex: currentPage.index,
              onItemTap: wm.setCurrentPage,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: IndexedStack(
                        index: currentPage.index,
                        children: [
                          ArtistsNavigator(navigatorKey: wm.navigatorKeys[TypePage.artists]!),
                          SearchNavigator(navigatorKey: wm.navigatorKeys[TypePage.search]!),
                          CollectionNavigator(navigatorKey: wm.navigatorKeys[TypePage.collection]!),
                        ],
                      ),
                    ),
                    PlayerBar(
                      isShow: wm.isShowPlayerBar,
                      curretnDurationValue: wm.durationTrack,
                      onOpenPlayer: wm.onOpenPlayer,
                      artistName: wm.artistName,
                      trackName: wm.trackName,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
