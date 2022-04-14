// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

const _bottomNavigationBarHeight = 48.0;

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onItemTap;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      _BottomNavigationBarItem(
        iconData: Icons.library_music,
        label: 'Исполнители',
        key: const Key('artists_key'),
      ),
      _BottomNavigationBarItem(
        iconData: Icons.search,
        label: 'Поиск',
        key: const Key('search_key'),
      ),
      _BottomNavigationBarItem(
        iconData: Icons.favorite_border,
        label: 'Коллекция',
        key: const Key('collection_key'),
      ),
    ];
    const homeIndicatorHeight = 34.0;
    final isIOS = Platform.isIOS;

    return Container(
      height: isIOS ? _bottomNavigationBarHeight + homeIndicatorHeight : _bottomNavigationBarHeight,
      color: ColorConstants.deepBlack,
      child: Column(
        children: [
          _BottomNavigationBar(
            items: items,
            currentIndex: currentIndex,
            onTap: onItemTap,
          ),
          if (isIOS) const SizedBox(height: homeIndicatorHeight),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final List<_BottomNavigationBarItem> items;
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomNavigationBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            _NavigationBarItem(
              iconData: items[i].iconData,
              label: items[i].label,
              index: i,
              currentIndex: currentIndex,
              onTap: onTap,
              key: items[i].key,
            ),
        ],
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final int index;
  final int currentIndex;
  final void Function(int) onTap;

  const _NavigationBarItem({
    Key? key,
    required this.iconData,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = index == currentIndex ? ColorConstants.primary : Colors.white;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        radius: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Icon(
                  iconData,
                  color: color,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  label,
                  style: TextStyle(
                    textBaseline: TextBaseline.ideographic,
                    letterSpacing: -0.41,
                    fontSize: 10,
                    color: color,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationBarItem {
  final IconData iconData;
  final String label;
  final Key key;

  _BottomNavigationBarItem({
    required this.iconData,
    required this.label,
    required this.key,
  });
}
