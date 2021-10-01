import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/domain/repository/movie_repository.dart';
import 'package:swing_trimmer/infra/repository/movie_repository_impl.dart';

final movieDetailVm = Provider((ref) => MovieDetailViewModel(ref.read));

class MovieDetailViewModel {
  MovieDetailViewModel(this._read);
  final Reader _read;
  MovieRepository get _repo => _read(movieRepository);

  Future<void> toggleFavorite(Movie entity) async {
    final newEntity = entity.copyWith(isFavorite: !entity.isFavorite);
    return _repo.store(newEntity);
  }

  Future<void> readIfNecessary(Movie entity) async {
    if (entity.isRead) {
      return;
    }

    final newEntity = entity.copyWith(isRead: true);
    return _repo.store(newEntity);
  }

  Future<void> saveToGallery() async {}
  Future<void> delete() async {}
  Future<void> changeSwingAt() async {}
}
