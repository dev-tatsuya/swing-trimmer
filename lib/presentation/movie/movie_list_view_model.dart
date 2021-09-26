import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/domain/repository/movie_repository.dart';
import 'package:swing_trimmer/infra/repository/movie_repository_impl.dart';
import 'package:swing_trimmer/presentation/movie/state/movie_list_state.dart';

final movieListVm = StateNotifierProvider<MovieListViewModel, MovieListState>(
    (ref) => MovieListViewModel(ref.read));

class MovieListViewModel extends StateNotifier<MovieListState> {
  MovieListViewModel(this._read) : super(const MovieListState()) {
    fetch();
  }
  final Reader _read;
  MovieRepository get _repo => _read(movieRepository);

  Future<void> fetch() async {
    final movies = await _repo.fetch();
    state = state.copyWith(moviesMap: _convertMap(movies));
  }

  Future<void> refresh() async => fetch();

  Future<void> save(Movie entity) async {
    return _repo.store(entity);
  }

  Future<void> delete(Movie entity) async {
    await _repo.delete(entity);
    refresh();
  }

  Future<XFile?> pick() async {
    return await _repo.pick();
  }

  Future<void> pickAndSaveMovie() async {
    final file = await _repo.pick();
    if (file == null) {
      return;
    }

    await _repo.saveImageAndMovieToDBAndFileAfterTrimmingThumbnail(file);
    refresh();
  }

  Map<String, List<Movie>> _convertMap(List<Movie> movies) {
    Map<String, List<Movie>> moviesMap = {};

    for (final movie in movies) {
      final swungAt = dateString(movie.swungAt) ?? '未設定';
      if (moviesMap[swungAt] == null || moviesMap[swungAt]!.isEmpty) {
        moviesMap[swungAt] = [movie];
      } else {
        moviesMap[swungAt] = [...moviesMap[swungAt]!, movie];
      }
    }

    return moviesMap;
  }

  String? dateString(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
}
