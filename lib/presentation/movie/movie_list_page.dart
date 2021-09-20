import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:swing_trimmer/presentation/common_widget/custom_app_bar.dart';
import 'package:swing_trimmer/presentation/movie/movie_detail_page.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';

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
        onPressed: () {
          ref.read(movieListVm.notifier).pickAndSaveMovie();
        },
        child: const Icon(Icons.video_library_outlined),
      ),
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
            children: moviesMap[dateList[index]]!.map((e) {
              return GestureDetector(
                onTap: () {
                  print('moviePath: ${e.moviePath}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: e),
                    ),
                  );
                },
                onLongPress: () {
                  ref.read(movieListVm.notifier).delete(e);
                },
                child: Image.file(
                  File(e.thumbnailPath!),
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
