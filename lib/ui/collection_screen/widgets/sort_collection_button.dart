// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

class SortCollectionButton extends StatelessWidget {
  final void Function() onSortCollection;

  const SortCollectionButton({
    Key? key,
    required this.onSortCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: IconButton(
        onPressed: onSortCollection,
        iconSize: 32,
        icon: const Icon(
          Icons.sort_rounded,
          color: ColorConstants.primary,
        ),
      ),
    );
  }
}
