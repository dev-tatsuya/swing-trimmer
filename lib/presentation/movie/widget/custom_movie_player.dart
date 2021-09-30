import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:swing_trimmer/presentation/movie/widget/custom_controls.dart';

class CustomMoviePlayer extends StatelessWidget {
  const CustomMoviePlayer({
    Key? key,
    required this.flickManager,
    this.chipRow,
    this.isCutOff = false,
  }) : super(key: key);

  final FlickManager flickManager;
  final List<Widget>? chipRow;
  final bool isCutOff;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 44, bottom: 34),
      child: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              final width = MediaQuery.of(context).size.width;
              final duration =
                  flickManager.flickVideoManager?.videoPlayerValue?.duration;
              if (duration == null) {
                return;
              }
              final rate = details.delta.dx / width;
              final moveMillSecond =
                  (duration.inMilliseconds * rate ~/ 5).abs();

              if (details.delta.dx > 0) {
                flickManager.flickControlManager
                    ?.seekForward(Duration(milliseconds: moveMillSecond));
              }

              if (details.delta.dx < 0) {
                flickManager.flickControlManager
                    ?.seekBackward(Duration(milliseconds: moveMillSecond));
              }
            },
            onPanStart: (details) {
              flickManager.flickControlManager?.play();
            },
            onPanEnd: (details) {
              flickManager.flickControlManager?.pause();
            },
            onDoubleTap: () {
              flickManager.flickControlManager?.togglePlay();
            },
            child: FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                controls: CustomControls(
                  flickManager: flickManager,
                  isCutOff: isCutOff,
                ),
              ),
            ),
          ),
          if (isCutOff)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 44 + 4, right: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: chipRow ?? [],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
