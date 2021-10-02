import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/main.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_detail_view_model.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';
import 'package:swing_trimmer/presentation/movie/widget/custom_movie_player.dart';
import 'package:swing_trimmer/util/string.dart';
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

  void _saveToGallery() async {
    final ok = await vm.saveToGallery(movie.moviePath);
    showOkAlertDialog(
        context: context, title: '端末への保存に${ok ? '成功' : '失敗'}しました');
  }

  void _delete() async {
    if (movie.isFavorite) {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: 'お気に入り登録されています',
        message: '本当に削除しますか？',
      );

      if (result == OkCancelResult.cancel) {
        return;
      }
    }

    vm.delete(movie);
    Navigator.pop(context);
    ref.read(movieListVm.notifier).refresh();
  }

  void _changeSwungAt() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: movie.swungAt ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale("ja"),
    );
    print('pickedDate: $pickedDate');
    if (pickedDate == null) {
      return;
    }
    await vm.changeSwungAt(movie, pickedDate);
    showOkAlertDialog(
      context: context,
      title: '${dateStringWithWeek(pickedDate)}\nに変更しました',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
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
                onTap: _changeSwungAt,
                child: const Icon(Icons.date_range_outlined, size: iconSize),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _saveToGallery,
                child: const Icon(Icons.save_alt, size: iconSize),
              ),
              const SizedBox(width: 48),
              GestureDetector(
                onTap: _delete,
                child: const Icon(Icons.delete, size: iconSize),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: CustomMoviePlayer(flickManager: _flickManager),
        ),
      ),
    );
  }
}
