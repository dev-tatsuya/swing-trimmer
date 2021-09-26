import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/presentation/movie/movie_list_view_model.dart';

class MovieListBottomSheet extends ConsumerWidget {
  const MovieListBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
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
                  print(file?.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_auto, size: 24),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('ベータ版'),
                  ),
                ),
                title: const Text('自動で動画を分割する'),
                onTap: () {
                  Navigator.pop(context);
                  // ref.read(movieListVm.notifier).pickAndSaveMovie();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
