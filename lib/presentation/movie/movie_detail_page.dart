import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:video_player/video_player.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late FlickManager _flickManager;

  @override
  void initState() {
    super.initState();
    _flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.file(File(widget.movie.moviePath ?? '')),
    );
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 44, bottom: 34),
        child: GestureDetector(
          onPanUpdate: (details) {
            final width = MediaQuery.of(context).size.width;
            final duration =
                _flickManager.flickVideoManager?.videoPlayerValue?.duration;
            if (duration == null) {
              return;
            }
            final rate = details.delta.dx / width;
            final moveMillSecond = (duration.inMilliseconds * rate ~/ 5).abs();

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
      ),
    );
  }
}

class CustomOrientationControls extends StatefulWidget {
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
  State<CustomOrientationControls> createState() =>
      _CustomOrientationControlsState();
}

class _CustomOrientationControlsState extends State<CustomOrientationControls> {
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
