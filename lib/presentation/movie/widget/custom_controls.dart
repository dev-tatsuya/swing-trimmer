import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_view_model.dart';

class CustomControls extends ConsumerStatefulWidget {
  const CustomControls({
    Key? key,
    this.iconSize = 32,
    this.fontSize = 16,
    required this.flickManager,
    this.isCutOff = false,
  }) : super(key: key);
  final double iconSize;
  final double fontSize;
  final FlickManager flickManager;
  final bool isCutOff;

  @override
  _CustomControlsState createState() => _CustomControlsState();
}

class _CustomControlsState extends ConsumerState<CustomControls> {
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
                        if (widget.isCutOff)
                          GestureDetector(
                            onTap: () {
                              final position = widget
                                  .flickManager
                                  .flickVideoManager
                                  ?.videoPlayerValue
                                  ?.position;
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
                        if (widget.isCutOff) const SizedBox(width: 12),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.isCutOff ? cutOffText : baseText),
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

const cutOffText = '「追加」を押し、「○つのスイングを切り取る」を押すことでその時間の前後数秒間を切り取ることができます。'
    'この切り取る前後の秒数は設定により変更可能です。'
    'デフォルトでは切り取りたいスイングのトップの位置で「追加」を押すことで'
    '適切なスイングを切り取れるように設定してあります。'
    'スイングは複数切り取ることが可能です。\n'
    '$baseText';

const baseText = '以下の操作は、画面上のどこでも反応します。\n'
    '● ダブルタップで再生とポーズを切り替えられます。\n'
    '● 左右にドラッグすることで時間を進めたり戻したりできます（シークバーより細かい調整が可能です）。';
