// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

const _buttonHeight = 30.0;

class ConfirmationDialog extends StatelessWidget {
  final void Function(bool isDelete) onConfirmDeletion;

  const ConfirmationDialog({
    Key? key,
    required this.onConfirmDeletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 285,
        height: 141,
        decoration: BoxDecoration(
          color: ColorConstants.greyDeep,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const _Text(),
            SizedBox(
              height: _buttonHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Button(
                    text: 'Да',
                    onConfirmDeletion: () => onConfirmDeletion(true),
                  ),
                  _Button(
                    text: 'Нет',
                    onConfirmDeletion: () => onConfirmDeletion(false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 25, bottom: 21),
      child: Text(
        'Вы уверены, что хотите\nудалить трек?',
        style: TextStyle(
          fontSize: 17,
          height: 20 / 17,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final void Function() onConfirmDeletion;

  const _Button({
    Key? key,
    required this.text,
    required this.onConfirmDeletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onConfirmDeletion,
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(103, _buttonHeight),
        elevation: 0,
        side: const BorderSide(
          color: ColorConstants.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        primary: ColorConstants.primary,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
