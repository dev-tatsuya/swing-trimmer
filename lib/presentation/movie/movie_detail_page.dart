import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_detail_view_model.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';
import 'package:swing_trimmer/presentation/movie/widget/custom_movie_player.dart';
import 'package:video_player/video_player.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  late FlickManager _flickManager;
  late bool _isFavorite;

  Movie get movie => widget.movie;

  @override
  void initState() {
    super.initState();
    _flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.file(File(movie.moviePath ?? '')),
    );
    _isFavorite = movie.isFavorite;
    ref.read(movieDetailVm).readIfNecessary(movie);
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  static const double iconSize = 28;
  MovieDetailViewModel get vm => ref.read(movieDetailVm);

  void _toggleFavorite() {
    vm.toggleFavorite(movie);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _saveToGallery() {
    vm.saveToGallery();
  }

  void _delete() {
    vm.delete();
  }

  void _more() {
    vm.changeSwingAt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            ref.read(movieListVm.notifier).refresh();
          },
          child: const Icon(Icons.chevron_left, size: 36),
        ),
        actions: [
          GestureDetector(
            onTap: _toggleFavorite,
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red.withOpacity(0.8) : null,
              size: iconSize,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _saveToGallery,
            child: const Icon(Icons.save_alt, size: iconSize),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _delete,
            child: const Icon(Icons.delete, size: iconSize),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _more,
            child: const Icon(Icons.more_vert, size: iconSize),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomMoviePlayer(flickManager: _flickManager),
    );
  }
}
