import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_view_model.dart';

class CustomMoviePlayer extends ConsumerWidget {
  const CustomMoviePlayer({
    Key? key,
    this.chipRow,
    this.isCutOff = false,
    required this.controller,
  }) : super(key: key);

  final List<Widget>? chipRow;
  final bool isCutOff;
  final BetterPlayerController controller;

  void seekToPosition(DragUpdateDetails details, BuildContext context) {
    final videoController = controller.videoPlayerController;

    final width = MediaQuery.of(context).size.width;
    final duration = videoController?.value.duration;
    if (duration == null) {
      return;
    }
    final rate = details.delta.dx / width;
    final moveMillSecond = (duration.inMilliseconds * rate ~/ 5).abs();

    var goToMillSecond = videoController!.value.position.inMilliseconds;
    if (details.delta.dx > 0) {
      goToMillSecond += moveMillSecond;
    }

    if (details.delta.dx < 0) {
      goToMillSecond -= moveMillSecond;
    }
    controller.seekTo(Duration(milliseconds: goToMillSecond));
  }

  @override
  Widget build(BuildContext context, ref) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (_) => controller.videoPlayerController?.pause(),
          onPanUpdate: (details) => seekToPosition(details, context),
          child: BetterPlayer(controller: controller),
        ),
        if (isCutOff)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 48, right: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    final position =
                        controller.videoPlayerController!.value.position;
                    if (controller.videoPlayerController!.value.duration! <
                        position) {
                      return;
                    }
                    ref.read(movieCutOffVm).addCutOffPositionList(position);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4, right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text(
                          '追加',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: chipRow ?? [],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
