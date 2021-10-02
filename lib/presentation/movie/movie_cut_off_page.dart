import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/main.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_view_model.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';
import 'package:swing_trimmer/presentation/movie/widget/custom_movie_player.dart';
import 'package:swing_trimmer/presentation/movie/widget/position_chip.dart';
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

    List<Widget> chipRow = [];
    cutOffList.asMap().forEach((key, value) {
      chipRow.add(Padding(
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
            flickManager: _flickManager,
            chipRow: chipRow,
            isCutOff: true,
          ),
        ),
      ),
    );
  }
}
