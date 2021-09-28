import 'package:image_picker/image_picker.dart';
import 'package:swing_trimmer/domain/model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetch();
  Future<void> store(Movie entity);
  Future<void> delete(Movie entity);
  Future<XFile?> pick();
  Future<void> saveImageAndMovieToDBAndFileAfterTrimmingThumbnail(
      XFile? originMovieFile);
  Future<void> cutOffAndSave(String path, List<Duration> positions);
}
