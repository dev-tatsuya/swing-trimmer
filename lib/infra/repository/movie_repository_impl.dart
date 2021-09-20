import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/domain/repository/movie_repository.dart';
import 'package:swing_trimmer/infra/db/database.dart' as db;
import 'package:video_thumbnail/video_thumbnail.dart';

final movieRepository =
    Provider<MovieRepository>((ref) => MovieRepositoryImpl(db.MyDatabase()));

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._database);
  final db.MyDatabase _database;
  final ImagePicker _picker = ImagePicker();

  @override
  Future<List<Movie>> fetch() async {
    final List<db.Movie> dataModels = await _database.allMovieEntries;

    List<Movie> movieList = [];
    for (final model in dataModels) {
      movieList.add(Movie(
        id: model.id,
        title: model.title,
        thumbnailPath: model.thumbnailPath,
        moviePath: model.moviePath,
        isFavorite: model.isFavorite,
        swungAt: model.swungAt,
      ));
    }

    return movieList;

    return _mockMovieList();
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

  @override
  Future<XFile?> pick() async {
    return _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 10),
    );
  }

  @override
  Future<void> saveImageAndMovieToDBAndFileAfterTrimmingThumbnail(
      XFile? movieFile) async {
    final localPath = await _localPath;
    // 動画のサムネイル画像を取得し、その画像をファイルストレージに保存する
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: movieFile!.path,
      thumbnailPath: localPath,
    );

    // 動画のパスを作成し、その動画をファイルストレージに保存する
    final filename = basename(movieFile.path);
    final moviePath = '$localPath/$filename}';
    await movieFile.saveTo(moviePath);

    // DBにそれぞれのpathを保存する
    await _database.addMovie(db.MoviesCompanion(
      title: Value(filename),
      thumbnailPath: Value(thumbnailPath!),
      moviePath: Value(moviePath),
      isFavorite: const Value(false),
      swungAt: Value(await movieFile.lastModified()),
    ));
  }

  Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<List<Movie>> _mockMovieList() async {
    final dir = await _localPath;
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
}
