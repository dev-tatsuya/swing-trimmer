import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    Map<DateTime?, List<Movie>> moviesMap = {};

    for (final movie in movies) {
      if (moviesMap[movie.swungAt] == null ||
          moviesMap[movie.swungAt]!.isEmpty) {
        moviesMap[movie.swungAt] = [movie];
      } else {
        moviesMap[movie.swungAt] = [...moviesMap[movie.swungAt]!, movie];
      }
    }

    log('moviesMap: $moviesMap');

    state = state.copyWith(moviesMap: moviesMap);
  }

  Future<void> save(Movie entity) async {
    return _repo.store(entity);
  }

  Future<void> delete(int id) async {
    return _repo.delete(id);
  }
}

class DateMovieList {
  DateMovieList(this.date, this.movieList);
  final DateTime? date;
  final List<Movie>? movieList;
}
