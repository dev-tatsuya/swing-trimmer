import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/presentation/movie/movie_cut_off_view_model.dart';

class PositionChip extends ConsumerWidget {
  const PositionChip({
    Key? key,
    required this.position,
    required this.index,
    required this.onSeekTo,
  }) : super(key: key);

  final Duration? position;
  final int index;
  final ValueChanged<Duration> onSeekTo;

  @override
  Widget build(BuildContext context, ref) {
    if (position == null) {
      return Container();
    }

    final positionInSeconds =
        (position! - Duration(minutes: position!.inMinutes))
            .inSeconds
            .toString()
            .padLeft(2, '0');
    final positionStr = '${position!.inMinutes}:$positionInSeconds';

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                onSeekTo(position!);
              },
              child: Text(positionStr),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                ref.read(movieCutOffVm).removeAt(index);
              },
              child: const Icon(Icons.clear, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
