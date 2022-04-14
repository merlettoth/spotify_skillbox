// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const sizeContainer = 50.0;
    const sizeCircle = 30.0;

    return SizedBox(
      width: double.infinity,
      height: sizeContainer + 10,
      child: Center(
        child: Container(
          width: sizeContainer,
          height: sizeContainer,
          decoration: BoxDecoration(
            color: ColorConstants.blackMatte,
            borderRadius: BorderRadius.circular(sizeContainer / 2),
          ),
          child: const Center(
            child: SizedBox(
              width: sizeCircle,
              height: sizeCircle,
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
