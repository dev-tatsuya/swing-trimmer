import 'dart:developer';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swing_trimmer/domain/model/club.dart';
import 'package:swing_trimmer/domain/model/movie.dart';
import 'package:swing_trimmer/domain/repository/movie_repository.dart';
import 'package:swing_trimmer/infra/db/database.dart' as db;

enum BodyPart {
  leftShoulder,
  rightShoulder,
  leftElbow,
  leftWrist,
}

class BodyPoint {
  BodyPoint(this.bodyPart, this.x, this.y);
  final BodyPart bodyPart;
  final double x;
  final double y;

  @override
  String toString() {
    return 'BodyPoint({bodyPart: $bodyPart, x: $x, y: $y})';
  }
}

class PosePosition {
  PosePosition(this.id, this.bodyPoints);
  final int id;
  final List<BodyPoint> bodyPoints;

  @override
  String toString() {
    return 'PosePosition({id: $id, bodyPoints: $bodyPoints})';
  }
}

class LeftWristHeight {
  LeftWristHeight(this.index, this.y);
  final int index;
  final double y;

  @override
  String toString() {
    return 'LeftWristHeight({index: $index, y: $y})';
  }
}

final movieRepository =
    Provider<MovieRepository>((ref) => MovieRepositoryImpl(db.MyDatabase()));

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._database);
  final db.MyDatabase _database;
  final ImagePicker _picker = ImagePicker();
  final FlutterFFprobe _ffprobe = FlutterFFprobe();
  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();
  static const fps = 30;

  @override
  Future<List<Movie>> fetch() async {
    final List<db.Movie> dataModels = await _database.allMovieEntries;
    final path = await _localPath;

    List<Movie> movieList = [];
    for (final model in dataModels) {
      movieList.add(Movie(
        id: model.id,
        thumbnailPath: '$path/${model.thumbnailPath}',
        moviePath: '$path/${model.moviePath}',
        isFavorite: model.isFavorite,
        isRead: model.isRead,
        swungAt: model.swungAt,
        club: EnumToString.fromString(Club.values, model.club) ?? Club.none,
      ));
    }

    return movieList;
  }

  // Future<List<IndexMoviePath>> estimate(String moviePath) async {
  //   final tmpPath = await _tmpPath;
  //   final res = await Tflite.loadModel(
  //       model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  //   log('loadModel result: $res');
  //
  //   final List<LeftWristHeight> leftWristHeight = [];
  //
  //   // TODO: 700をどう決めるか
  //   // fps * 動画秒数？
  //   final indexList = [for (var i = 1; i <= 700; i++) i];
  //   for (final index in indexList) {
  //     final indexStr = index.toString().padLeft(4, '0');
  //     var recognitions = await Tflite.runPoseNetOnImage(
  //       path: '$tmpPath/image$indexStr.png',
  //       numResults: 1,
  //     );
  //
  //     final keyPoints = recognitions![0]['keypoints'];
  //
  //     if (keyPoints[5]['x'] < keyPoints[6]['x']) {
  //       leftWristHeight.add(LeftWristHeight(index, 1));
  //       continue;
  //     }
  //
  //     if (keyPoints[7]['y'] < keyPoints[9]['y']) {
  //       leftWristHeight.add(LeftWristHeight(index, 1));
  //       continue;
  //     }
  //
  //     leftWristHeight.add(LeftWristHeight(index, keyPoints[9]['y']));
  //   }
  //
  //   Tflite.close();
  //
  //   final List<LeftWristHeight> list = leftWristHeight
  //       .map((e) => LeftWristHeight(e.index, 1.0 - e.y))
  //       .toList();
  //   log('yList: $list');
  //
  //   double lastHeight = 0;
  //   double lastHeightDelta = 0;
  //   List<int> maybeHitIndexList = [];
  //
  //   for (final height in list) {
  //     final currentDelta = height.y - lastHeight;
  //     if ((0 < lastHeightDelta && lastHeightDelta < 0.1) &&
  //         (-0.1 < currentDelta && currentDelta <= 0)) {
  //       maybeHitIndexList.add(height.index);
  //     }
  //
  //     lastHeight = height.y;
  //     lastHeightDelta = currentDelta;
  //   }
  //
  //   log('maybeHitIndexList: $maybeHitIndexList');
  //
  //   final hitIndexList = findHitIndexList(maybeHitIndexList);
  //   log('hitIndexList: $hitIndexList');
  //
  //   return await cutOffMovie(hitIndexList, moviePath);
  // }

  Future<List<IndexMoviePath>> cutOffMovie(
      List<int> indexList, String moviePath) async {
    final localPath = await _localPath;
    final realTimeList =
        indexList.map((e) => (e * 1000 / fps).round() / 1000).toList();
    final List<IndexMoviePath> outputPathList = [];

    realTimeList.asMap().forEach((index, realTime) async {
      var startSecond = realTime - 2.0;
      if (startSecond < 0) {
        startSecond = 0;
      }

      final now = DateTime.now();
      final datePath =
          '${now.year}${now.month}${now.day}-${now.hour}${now.minute}${now.second}';
      final outputPath =
          '$localPath/$datePath-cut-off-index${indexList[index]}${extension(moviePath)}';
      outputPathList.add(IndexMoviePath(outputPath, index: indexList[index]));
      _ffmpeg
          .execute('-ss $startSecond -i $moviePath -t 6 -c copy $outputPath')
          .then(
              (result) => log('FFmpeg cut off process exited with rc $result'));
    });

    return outputPathList;
  }

  List<int> findHitIndexList(List<int> maybeHitIndexList) {
    final List<int> hitIndexList = [];
    final indexList = [for (var i = 0; i < maybeHitIndexList.length; i++) i];

    for (final i in indexList) {
      final List<int> indexGroup = [];
      try {
        indexGroup.add(maybeHitIndexList[i]);
      } catch (e) {
        break;
      }

      final min = maybeHitIndexList[i];
      bool hasNext = true;

      while (hasNext && maybeHitIndexList[i + 1] < min + fps) {
        indexGroup.add(maybeHitIndexList[i + 1]);
        maybeHitIndexList.removeAt(i + 1);
        hasNext = maybeHitIndexList.length > i + 1;
      }

      final ave = indexGroup.reduce((a, b) => a + b) / indexGroup.length;
      final hitIndex = ave.round();
      hitIndexList.add(hitIndex);
    }

    return hitIndexList;
  }

  @override
  Future<void> store(Movie entity) async {
    final dataModel = db.Movie(
      id: entity.id ?? -1,
      thumbnailPath: basename(entity.thumbnailPath ?? ''),
      moviePath: basename(entity.moviePath ?? ''),
      isFavorite: entity.isFavorite,
      isRead: entity.isRead,
      swungAt: entity.swungAt,
      club: EnumToString.convertToString(entity.club),
    );
    return _database.updateMovie(dataModel);
  }

  @override
  Future<void> delete(Movie entity) async {
    if (entity.id == null) {
      return;
    }
    await _database.deleteMovie(entity.id!);

    if (entity.thumbnailPath == null || entity.moviePath == null) {
      return;
    }

    // Documentディレクトリ内のファイル削除
    final imageDir = Directory(entity.thumbnailPath!);
    final movieDir = Directory(entity.moviePath!);
    imageDir.delete(recursive: true);
    movieDir.delete(recursive: true);
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
      XFile? originMovieFile) async {
    if (originMovieFile == null) {
      return;
    }

    // 元動画の撮影日を取得
    final mediaInformation =
        await _ffprobe.getMediaInformation(originMovieFile.path);
    Map<dynamic, dynamic>? mp = mediaInformation.getMediaProperties();
    final String? creationDateStr =
        mp == null ? null : mp["tags"]["com.apple.quicktime.creationdate"];
    final creationDate = DateTime.tryParse(creationDateStr ?? '');
    log('mp["tags"]["com.apple.quicktime.creationdate"] creationDate: $creationDate');

    final tmpPath = await _tmpPath;

    // 分割する
    final result = await _ffmpeg
        .execute('-i ${originMovieFile.path} -r 30 $tmpPath/image%04d.png');
    log('FFmpeg divide process exited with rc $result');

    // 姿勢推定をして、ストレージに動画を保存
    // ストレージに保存されたパスのリストを返す
    // final indexMoviePathList = await estimate(originMovieFile.path);
    // log('indexMoviePathList: $indexMoviePathList');

    // for (final indexMoviePath in indexMoviePathList) {
    //   // トップの画像をドキュメントストレージに保存する
    //   final thumbnailPath = indexMoviePath.moviePath
    //       .replaceFirst(extension(indexMoviePath.moviePath), '.png');
    //   final indexStr = indexMoviePath.index.toString().padLeft(4, '0');
    //   XFile('$tmpPath/image$indexStr.png').saveTo(thumbnailPath);
    //
    //   // DBにそれぞれのpathを保存する
    //   await _database.addMovie(db.MoviesCompanion(
    //     thumbnailPath: Value(basename(thumbnailPath)),
    //     moviePath: Value(basename(indexMoviePath.moviePath)),
    //     swungAt: Value(creationDate),
    //   ));
    // }
  }

  Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<String> get _tmpPath async {
    if (Platform.isIOS) {
      final docPath = (await getApplicationDocumentsDirectory()).path;
      return docPath.replaceFirst('Documents', 'tmp');
    }

    if (Platform.isAndroid) {
      // TODO: implement
    }

    return (await getTemporaryDirectory()).path;
  }

  @override
  Future<void> cutOffAndSave(String path, List<Duration> positions) async {
    // 元動画の撮影日を取得
    final mediaInformation = await _ffprobe.getMediaInformation(path);
    Map<dynamic, dynamic>? mp = mediaInformation.getMediaProperties();
    final String? creationDateStr =
        mp == null ? null : mp["tags"]["com.apple.quicktime.creationdate"];
    final creationDate = DateTime.tryParse(creationDateStr ?? '');
    log('mp["tags"]["com.apple.quicktime.creationdate"] creationDate: $creationDate');

    final outputPathList = await createOutputPathList(path, positions);
    for (final outputPath in outputPathList) {
      final moviePath = outputPath.moviePath;
      final imagePath = moviePath.replaceFirst(extension(path), '.png');
      log('imagePath: $imagePath');
      final result = await _ffmpeg.execute(
          '-i $moviePath -ss 0 -f image2 -vframes 1 -vf scale=-1:360 $imagePath');
      log('FFmpeg cut off image process exited with rc $result');

      // DBにそれぞれのpathを保存する
      await _database.addMovie(db.MoviesCompanion(
        thumbnailPath: Value(basename(imagePath)),
        moviePath: Value(basename(outputPath.moviePath)),
        swungAt: Value(creationDate),
      ));
    }

    // pathにある動画を削除する
    Directory(path).delete(recursive: true);
  }

  Future<List<IndexMoviePath>> createOutputPathList(
      String originPath, List<Duration> positions) async {
    final localPath = await _localPath;

    final List<IndexMoviePath> outputPathList = [];
    await Future.forEach(positions, (Duration position) async {
      final positionInSeconds =
          (position - Duration(minutes: position.inMinutes))
              .inSeconds
              .toString()
              .padLeft(2, '0');
      final positionStr = '${position.inMinutes}:$positionInSeconds';

      final realTime = position.inMilliseconds / 1000;
      var startSecond = realTime - 2.0;
      if (startSecond < 0) {
        startSecond = 0;
      }

      final now = DateTime.now();
      final datePath =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
      final outputPath =
          '$localPath/$datePath-cut-off-$positionStr${extension(originPath)}';
      outputPathList.add(IndexMoviePath(outputPath));
      final result = await _ffmpeg
          .execute('-ss $startSecond -i $originPath -t 6 -c copy $outputPath');
      log('FFmpeg cut off video process exited with rc $result');
    });

    return outputPathList;
  }

  @override
  Future<bool?> saveMovieToGallery(String path) async {
    // 無課金
    if (false) {
      await _saveLogoToTmp();
      final tempPath = '${await _tmpPath}/with-logo${extension(path)}';
      final result = await _ffmpeg.execute(
          '-i $path -i ${await _tmpPath}/logo.png -filter_complex [0:v]overlay=W-w:H-h $tempPath');
      log('FFmpeg merge logo into video process exited with rc $result');
      return GallerySaver.saveVideo(tempPath);
    }

    // 課金
    return GallerySaver.saveVideo(path);
  }

  Future<void> _saveLogoToTmp() async {
    await _getImageFileFromAssets('logo.png');
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/images/$path');

    final file = File('${await _tmpPath}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}

class IndexMoviePath {
  IndexMoviePath(
    this.moviePath, {
    this.index = -1,
    this.imagePath = '',
  });
  final int index;
  final String moviePath;
  final String imagePath;
}
