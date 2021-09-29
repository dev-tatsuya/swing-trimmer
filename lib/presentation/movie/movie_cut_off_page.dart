import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_view_model.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';
import 'package:video_player/video_player.dart';

class MovieCutOffPage extends ConsumerStatefulWidget {
  const MovieCutOffPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  _MovieCutOffPageState createState() => _MovieCutOffPageState();
}

class _MovieCutOffPageState extends ConsumerState<MovieCutOffPage> {
  late FlickManager _flickManager;

  @override
  void initState() {
    super.initState();
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(widget.path)),
    );
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cutOffList = ref.watch(cutOffPositionList).state;

    List<Widget> children = [];
    cutOffList.asMap().forEach((key, value) {
      children.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: PositionChip(
          position: value,
          index: key,
          onSeekTo: (position) {
            _flickManager.flickControlManager?.seekTo(position);
          },
        ),
      ));
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () async {
                  await ref.read(movieCutOffVm).cutOff(widget.path);
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ref.read(movieListVm.notifier).refresh();
                },
                child: Text(
                  '${cutOffList.length}つのスイングを切り取る',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 44, bottom: 34),
        child: Stack(
          children: [
            FlickVideoPlayer(
              flickManager: _flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                controls: CustomOrientationControls(
                  flickVideoManager: _flickManager.flickVideoManager,
                  flickControlManager: _flickManager.flickControlManager,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 44 + 4, right: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositionChip extends ConsumerWidget {
  const PositionChip({
    Key? key,
    required this.position,
    required this.index,
    required this.onSeekTo,
  }) : super(key: key);

  final Duration? position;
  final int index;
  final ValueChanged<Duration> onSeekTo;

  @override
  Widget build(BuildContext context, ref) {
    if (position == null) {
      return Container();
    }

    final positionInSeconds =
        (position! - Duration(minutes: position!.inMinutes))
            .inSeconds
            .toString()
            .padLeft(2, '0');
    final positionStr = '${position!.inMinutes}:$positionInSeconds';

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                onSeekTo(position!);
              },
              child: Text(positionStr),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                ref.read(movieCutOffVm).removeAt(index);
              },
              child: const Icon(Icons.clear, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomOrientationControls extends ConsumerWidget {
  const CustomOrientationControls(
      {Key? key,
      this.iconSize = 20,
      this.fontSize = 16,
      this.flickVideoManager,
      this.flickControlManager})
      : super(key: key);
  final double iconSize;
  final double fontSize;
  final FlickVideoManager? flickVideoManager;
  final FlickControlManager? flickControlManager;

  @override
  Widget build(BuildContext context, ref) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Container(color: Colors.black26),
          ),
        ),
        const Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickAutoHideChild(
                  child: FlickPlayToggle(size: 50),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          final position =
                              flickVideoManager?.videoPlayerValue?.position;
                          ref
                              .read(movieCutOffVm)
                              .addCutOffPositionList(position);
                        },
                        child: Container(
                          decoration: BoxDecoration(
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
                    const SizedBox(height: 4),
                    FlickVideoProgressBar(
                      onDragUpdate: () {},
                      flickProgressBarSettings: FlickProgressBarSettings(
                        height: 10,
                        handleRadius: 10,
                        curveRadius: 50,
                        backgroundColor: Colors.white24,
                        bufferedColor: Colors.white38,
                        playedColor: Colors.red,
                        handleColor: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        const FlickPlayToggle(),
                        const SizedBox(width: 8),
                        const FlickSoundToggle(),
                        const SizedBox(width: 8),
                        Row(
                          children: <Widget>[
                            FlickCurrentPosition(
                              fontSize: fontSize,
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                            FlickTotalDuration(
                              fontSize: fontSize,
                            ),
                          ],
                        ),
                        const Spacer(),
                        FlickSetPlayBack(
                          playBackChild: const Text(
                            '×1.0',
                            style: TextStyle(fontSize: 16),
                          ),
                          setPlayBack: () {
                            flickControlManager?.setPlaybackSpeed(1.0);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
