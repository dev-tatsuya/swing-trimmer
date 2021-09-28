import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/infra/repository/movie_repository_impl.dart';

final cutOffPositionList =
    StateProvider.autoDispose<List<Duration>>((ref) => []);

final movieCutOffVm = Provider((ref) => MovieCutOffViewModel(ref.read));

class MovieCutOffViewModel {
  MovieCutOffViewModel(this._read);
  final Reader _read;

  void addCutOffPositionList(Duration? duration) {
    if (duration == null) {
      return;
    }

    _read(cutOffPositionList).state = _read(cutOffPositionList).state.isEmpty
        ? [duration]
        : [..._read(cutOffPositionList).state, duration];
  }

  void removeAt(int index) {
    final List<Duration> newList = [];
    _read(cutOffPositionList).state.asMap().forEach((key, value) {
      if (key != index) {
        newList.add(value);
      }
    });
    _read(cutOffPositionList).state = newList;
  }

  Future<void> cutOff(String path) async {
    return _read(movieRepository)
        .cutOffAndSave(path, _read(cutOffPositionList).state);
  }
}
