// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/ui/widgets/loading_widget.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

const _widgetWidth = 200.0;
const _widgetHeight = 50.0;

class LoadingTracksButton extends StatelessWidget {
  final ValueNotifier<bool> isLoadingTracks;
  final Future<void> Function() onLoadTracks;
  final ValueNotifier<bool> isAllSongsReceived;

  const LoadingTracksButton({
    Key? key,
    required this.isLoadingTracks,
    required this.onLoadTracks,
    required this.isAllSongsReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isAllSongsReceived,
      builder: (_, isAllSongsReceived, __) {
        if (isAllSongsReceived) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25, top: 10),
                child: ValueListenableBuilder<bool>(
                  valueListenable: isLoadingTracks,
                  builder: (_, isLoadingTracks, __) {
                    if (isLoadingTracks) {
                      return const _AnimationLoading();
                    } else {
                      return _Button(onLoadTracks: onLoadTracks);
                    }
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class _Button extends StatelessWidget {
  final Future<void> Function() onLoadTracks;

  const _Button({
    Key? key,
    required this.onLoadTracks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _widgetWidth,
      height: _widgetHeight,
      child: ElevatedButton(
        onPressed: onLoadTracks,
        style: ElevatedButton.styleFrom(
          primary: ColorConstants.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Text(
          'Загрузить ещё',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _AnimationLoading extends StatefulWidget {
  const _AnimationLoading({Key? key}) : super(key: key);

  @override
  State<_AnimationLoading> createState() => _AnimationLoadingState();
}

class _AnimationLoadingState extends State<_AnimationLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimationWidget(value: _controller);
  }
}

class AnimationWidget extends AnimatedWidget {
  Animation<double> get animation => listenable as Animation<double>;

  const AnimationWidget({
    Key? key,
    required Animation<double> value,
  }) : super(key: key, listenable: value);

  @override
  Widget build(BuildContext context) {
    final width = _widgetWidth - ((_widgetWidth - _widgetHeight) * animation.value);
    return Container(
      width: width,
      height: _widgetHeight,
      decoration: BoxDecoration(
        color: ColorConstants.blackMatte,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const LoadingWidget(),
    );
  }
}
