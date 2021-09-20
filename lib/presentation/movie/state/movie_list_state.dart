import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swing_trimmer/domain/model/movie.dart';

part 'movie_list_state.freezed.dart';

@freezed
class MovieListState with _$MovieListState {
  const factory MovieListState({
    @Default({}) Map<String, List<Movie>> moviesMap,
  }) = _MovieListState;
}
