import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swing_trimmer/domain/model/club.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/domain/repository/movie_repository.dart';
import 'package:swing_trimmer/infra/repository/movie_repository_impl.dart';

final movieDetailVm = Provider((ref) => MovieDetailViewModel(ref.read));

class MovieDetailViewModel {
  MovieDetailViewModel(this._read);
  final Reader _read;
  MovieRepository get _repo => _read(movieRepository);

  Future<void> toggleFavorite(Movie entity) async {
    final newEntity =
        entity.copyWith(isFavorite: !entity.isFavorite, isRead: true);
    return _repo.store(newEntity);
  }

  Future<void> readIfNecessary(Movie entity) async {
    if (entity.isRead) {
      return;
    }

    final newEntity = entity.copyWith(isRead: true);
    return _repo.store(newEntity);
  }

  Future<bool> saveToGallery(String? path) async {
    if (path == null) {
      return false;
    }

    return (await _repo.saveMovieToGallery(path) ?? false);
  }

  Future<void> delete(Movie entity) async {
    return _repo.delete(entity);
  }

  Future<void> changeSwungAt(Movie entity, DateTime date) async {
    final newEntity = entity.copyWith(swungAt: date, isRead: true);
    return _repo.store(newEntity);
  }

  Future<void> selectClub(Movie entity, Club club) async {
    final newEntity = entity.copyWith(club: club, isRead: true);
    return _repo.store(newEntity);
  }
}
