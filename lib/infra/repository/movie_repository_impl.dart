import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/domain/repository/movie_repository.dart';

final movieRepository =
    Provider<MovieRepository>((ref) => MovieRepositoryImpl());

class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<List<Movie>> fetch() async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    final movies = [
      Movie(
        thumbnailPath: '$dir/trim.090D1638-400B-4A58-B992-273D9458C15D.png',
        swungAt: DateTime(2021, 9, 20),
      ),
      Movie(
        thumbnailPath: '$dir/trim.6DC0AB71-CC1D-4A13-96E9-735B9944305F.png',
        swungAt: DateTime(2021, 9, 20),
      ),
      Movie(
        thumbnailPath: '$dir/trim.8CE746AD-CB1A-46D4-822F-5F84BC09551B.png',
        swungAt: DateTime(2021, 9, 20),
      ),
      Movie(
        thumbnailPath: '$dir/trim.11AEED3B-95F1-45C2-8C9B-C48DEAF31F4A.png',
        swungAt: DateTime(2021, 9, 20),
      ),
      Movie(
        thumbnailPath: '$dir/trim.93B76BA8-20F5-43B8-AD5F-B1D49B60BC09.png',
        swungAt: DateTime(2021, 9, 19),
      ),
      Movie(
        thumbnailPath: '$dir/trim.2856CF56-81F1-471C-AB39-2AE279F0BFE2.png',
        swungAt: DateTime(2021, 9, 19),
      ),
      Movie(
        thumbnailPath: '$dir/trim.A1336677-C4C8-4320-A6C4-29FC743EF050.png',
        swungAt: DateTime(2021, 9, 19),
      ),
      Movie(
        thumbnailPath: '$dir/trim.EBA768E7-32A2-46A1-8C60-3B9CE99B5814.png',
        swungAt: DateTime(2021, 9, 19),
      ),
      Movie(
        thumbnailPath: '$dir/trim.090D1638-400B-4A58-B992-273D9458C15D.png',
        swungAt: DateTime(2021, 9, 18),
      ),
      Movie(
        thumbnailPath: '$dir/trim.6DC0AB71-CC1D-4A13-96E9-735B9944305F.png',
        swungAt: DateTime(2021, 9, 18),
      ),
      Movie(
        thumbnailPath: '$dir/trim.8CE746AD-CB1A-46D4-822F-5F84BC09551B.png',
        swungAt: DateTime(2021, 9, 18),
      ),
      Movie(
        thumbnailPath: '$dir/trim.11AEED3B-95F1-45C2-8C9B-C48DEAF31F4A.png',
        swungAt: DateTime(2021, 9, 18),
      ),
      Movie(
        thumbnailPath: '$dir/trim.93B76BA8-20F5-43B8-AD5F-B1D49B60BC09.png',
        swungAt: DateTime(2021, 9, 17),
      ),
      Movie(
        thumbnailPath: '$dir/trim.2856CF56-81F1-471C-AB39-2AE279F0BFE2.png',
        swungAt: DateTime(2021, 9, 17),
      ),
      Movie(
        thumbnailPath: '$dir/trim.A1336677-C4C8-4320-A6C4-29FC743EF050.png',
        swungAt: DateTime(2021, 9, 17),
      ),
      Movie(
        thumbnailPath: '$dir/trim.EBA768E7-32A2-46A1-8C60-3B9CE99B5814.png',
        swungAt: DateTime(2021, 9, 17),
      ),
    ];
    return movies;
  }

  @override
  Future<void> store(Movie entity) {
    // TODO: implement store
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
