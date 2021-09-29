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
        videoPlayerController: VideoPlayerController.file(File(widget.path)));
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
          onSeekTo: (position) async {
            await _flickManager.flickControlManager?.seekTo(position);
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
            GestureDetector(
              onPanUpdate: (details) {
                final width = MediaQuery.of(context).size.width;
                final duration =
                    _flickManager.flickVideoManager?.videoPlayerValue?.duration;
                if (duration == null) {
                  return;
                }
                final rate = details.delta.dx / width;
                final moveMillSecond =
                    (duration.inMilliseconds * rate ~/ 5).abs();

                if (details.delta.dx > 0) {
                  _flickManager.flickControlManager
                      ?.seekForward(Duration(milliseconds: moveMillSecond));
                }

                if (details.delta.dx < 0) {
                  _flickManager.flickControlManager
                      ?.seekBackward(Duration(milliseconds: moveMillSecond));
                }
              },
              onPanStart: (details) {
                _flickManager.flickControlManager?.play();
              },
              onPanEnd: (details) {
                _flickManager.flickControlManager?.pause();
              },
              onDoubleTap: () {
                _flickManager.flickControlManager?.togglePlay();
              },
              child: FlickVideoPlayer(
                flickManager: _flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  controls: CustomOrientationControls(
                    flickManager: _flickManager,
                  ),
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

class CustomOrientationControls extends ConsumerStatefulWidget {
  const CustomOrientationControls({
    Key? key,
    this.iconSize = 32,
    this.fontSize = 16,
    required this.flickManager,
  }) : super(key: key);
  final double iconSize;
  final double fontSize;
  final FlickManager flickManager;

  @override
  _CustomOrientationControlsState createState() =>
      _CustomOrientationControlsState();
}

class _CustomOrientationControlsState
    extends ConsumerState<CustomOrientationControls> {
  bool showHint = false;
  final playSpeedList = const [1.0, 0.25, 0.5, 0.75];
  int currentSpeedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          color: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FlickCurrentPosition(
                          fontSize: widget.fontSize,
                        ),
                        Text(
                          ' / ',
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.fontSize),
                        ),
                        FlickTotalDuration(
                          fontSize: widget.fontSize,
                        ),
                      ],
                    ),
                    FlickVideoProgressBar(
                      onDragUpdate: () {},
                      flickProgressBarSettings: FlickProgressBarSettings(
                        height: 8,
                        handleRadius: 8,
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
                        GestureDetector(
                          onTap: () {
                            final position = widget.flickManager
                                .flickVideoManager?.videoPlayerValue?.position;
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
                        const SizedBox(width: 12),
                        FlickPlayToggle(size: widget.iconSize),
                        const SizedBox(width: 12),
                        FlickSoundToggle(size: widget.iconSize),
                        const SizedBox(width: 12),
                        FlickSetPlayBack(
                          playBackChild: Text(
                            '×${playSpeedList[currentSpeedIndex]}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          setPlayBack: () {
                            late int nextIndex;
                            if (currentSpeedIndex == playSpeedList.length - 1) {
                              nextIndex = 0;
                            } else {
                              nextIndex = currentSpeedIndex + 1;
                            }

                            widget.flickManager.flickControlManager
                                ?.setPlaybackSpeed(playSpeedList[nextIndex]);
                            setState(() {
                              currentSpeedIndex = nextIndex;
                            });
                          },
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showHint = !showHint;
                            });
                          },
                          child: Column(
                            children: [
                              Icon(
                                  showHint
                                      ? Icons.close
                                      : Icons.lightbulb_outline,
                                  size: 24),
                              Text(
                                showHint ? '閉じる' : '使い方',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (showHint)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '「追加」を押し、「○つのスイングを切り取る」を押すことでその時間の前後数秒間を切り取ることができます。'
                            'この切り取る前後の秒数は設定により変更可能です。'
                            'デフォルトでは切り取りたいスイングのトップの位置で「追加」を押すことで'
                            '適切なスイングを切り取れるように設定してあります。'
                            'スイングは複数切り取ることが可能です。\n'
                            '以下の操作は、画面上のどこでも反応します。\n'
                            '● ダブルタップで再生とポーズを切り替えられます。\n'
                            '● 左右にドラッグすることで時間を進めたり戻したりできます（シークバーより細かい調整が可能です）。',
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
