// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

class SearchTextField extends StatelessWidget {
  final void Function(String artistName) onSearchArtists;

  const SearchTextField({
    Key? key,
    required this.onSearchArtists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextField(
        textInputAction: TextInputAction.go,
        onSubmitted: onSearchArtists,
        style: const TextStyle(fontSize: 17, height: 24 / 17),
        cursorWidth: 1,
        cursorColor: ColorConstants.grayMiddle,
        decoration: InputDecoration(
          fillColor: ColorConstants.blackMatte,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: ColorConstants.grayMiddle,
          ),
          contentPadding: const EdgeInsets.only(right: 26),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
        ),
      ),
    );
  }
}
