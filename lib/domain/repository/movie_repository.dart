import 'package:swing_trimmer/domain/model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetch();
  Future<void> store(Movie entity);
  Future<void> delete(int id);
}
