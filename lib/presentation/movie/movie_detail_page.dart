import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/widget/custom_movie_player.dart';
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
      body: CustomMoviePlayer(flickManager: _flickManager),
    );
  }
}
