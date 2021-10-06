import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/main.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_page.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';

class MovieListBottomSheet extends ConsumerWidget {
  const MovieListBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Wrap(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '新規作成',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.touch_app_outlined, size: 24),
                  title: const Text('手動で動画を分割する'),
                  onTap: () async {
                    final file = await ref.read(movieListVm.notifier).pick();
                    if (file == null) {
                      return;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieCutOffPage(path: file.path),
                          fullscreenDialog: true,
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flash_auto, size: 24),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: mainGreenColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Coming soon'),
                    ),
                  ),
                  title: const Text('自動で動画を分割する'),
                  onTap: () {
                    // ref.read(movieListVm.notifier).pickAndSaveMovie();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
