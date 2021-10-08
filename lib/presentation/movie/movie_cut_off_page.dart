import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/const/const.dart';
import 'package:swing_trimmer/main.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_view_model.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';
import 'package:swing_trimmer/presentation/movie/widget/custom_movie_player.dart';
import 'package:swing_trimmer/presentation/movie/widget/position_chip.dart';

class MovieCutOffPage extends ConsumerStatefulWidget {
  const MovieCutOffPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  _MovieCutOffPageState createState() => _MovieCutOffPageState();
}

class _MovieCutOffPageState extends ConsumerState<MovieCutOffPage> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
      aspectRatio: 1 / 2,
      fit: BoxFit.cover,
      autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableFullscreen: false,
        enableMute: false,
        enableSkips: false,
        enableOverflowMenu: false,
        playIcon: Icons.play_arrow,
        controlBarColor: Colors.black.withOpacity(0.4),
      ),
    ));

    final _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.path,
    );
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cutOffList = ref.watch(cutOffPositionList).state;

    List<Widget> chipRow = [];
    cutOffList.asMap().forEach((key, value) {
      chipRow.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: PositionChip(
          position: value,
          index: key,
          onSeekTo: (position) async {
            await _betterPlayerController.videoPlayerController
                ?.seekTo(position);
          },
        ),
      ));
    });

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            backgroundColor: Colors.black.withOpacity(0.4),
            leading: GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Directory(widget.path).delete(recursive: true);
              },
              child: const Icon(Icons.clear, size: 24),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  showOkAlertDialog(
                    context: context,
                    title: '使い方',
                    message: cutOffText,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lightbulb_outline, size: 24),
                    Text(
                      '使い方',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
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
          body: CustomMoviePlayer(
            controller: _betterPlayerController,
            chipRow: chipRow,
            isCutOff: true,
          ),
        ),
      ),
    );
  }
}
