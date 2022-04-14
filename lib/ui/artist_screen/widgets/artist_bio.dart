// Flutter imports:
import 'package:flutter/material.dart';

class ArtistBio extends StatelessWidget {
  final String bio;

  const ArtistBio({
    Key? key,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: bio == ''
          ? const SizedBox(height: 25)
          : Padding(
              padding: const EdgeInsets.all(25),
              child: Text(
                bio,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Color.fromRGBO(153, 153, 153, 1),
                  height: 1.5,
                ),
              ),
            ),
    );
  }
}
