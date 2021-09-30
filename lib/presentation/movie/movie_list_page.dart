import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_detail_page.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';
import 'package:swing_trimmer/presentation/movie/widget/movie_list_bottom_sheet.dart';

class MovieListPage extends ConsumerWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Swing Trimmer',
      ),
      body: _buildBody(ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalBottomSheet(context),
        child: const Icon(Icons.video_library_outlined),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) => const MovieListBottomSheet(),
    );
  }

  ListView _buildBody(WidgetRef ref) {
    final state = ref.watch(movieListVm);
    final moviesMap = state.moviesMap;
    final dateList = moviesMap.keys.toList();

    return ListView.builder(
      itemCount: moviesMap.length,
      itemBuilder: (context, index) {
        return StickyHeader(
          header: Container(
            height: 40,
            color: Colors.blueGrey[700],
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              dateList[index],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          content: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            key: UniqueKey(),
            crossAxisCount: 3,
            children: moviesMap[dateList[index]]!.map((movie) {
              final isFavorite = movie.isFavorite;

              return GestureDetector(
                onTap: () {
                  print('moviePath: ${movie.moviePath}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
                onLongPress: () {
                  ref.read(movieListVm.notifier).delete(movie);
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(movie.thumbnailPath!),
                      fit: BoxFit.cover,
                    ),
                    const Positioned(
                      right: 4,
                      top: 0,
                      child: Icon(
                        Icons.fiber_new_outlined,
                        color: Colors.pinkAccent,
                        size: 30,
                      ),
                    ),
                    if (isFavorite)
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red.withOpacity(0.8),
                          size: 24,
                        ),
                      )
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
