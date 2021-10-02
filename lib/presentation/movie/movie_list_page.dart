import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:swing_trimmer/domain/model/club.dart';
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
            height: 36,
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
              final isRead = movie.isRead;
              final isSelectedClub =
                  movie.club != null && movie.club != Club.none;

              final imageBox = Image.file(
                File(movie.thumbnailPath!),
                fit: BoxFit.cover,
              );

              final imageWidget = !isRead
                  ? ClipRect(
                      child: Banner(
                        location: BannerLocation.topEnd,
                        message: 'New',
                        child: imageBox,
                      ),
                    )
                  : imageBox;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageWidget,
                    if (isFavorite)
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red.withOpacity(0.8),
                          size: 24,
                        ),
                      ),
                    if (isSelectedClub)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          color: Colors.black45,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              movie.club!.displayName,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
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
