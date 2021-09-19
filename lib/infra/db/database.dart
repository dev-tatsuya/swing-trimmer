import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Movies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get thumbnailPath => text()();
  TextColumn get moviePath => text()();
  BoolColumn get isFavorite => boolean()();
  DateTimeColumn get swungAt => dateTime()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Movies])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Movie>> get allMovieEntries async => select(movies).get();

  Future updateMovie(Movie entry) async {
    return update(movies).replace(entry);
  }

  Future deleteMovie(int id) async {
    return (delete(movies)..where((e) => e.id.equals(id))).go();
  }

  Future<int> addMovie(MoviesCompanion entry) async {
    return into(movies).insert(entry);
  }

  Future<void> insertMultipleMovies(List<MoviesCompanion> list) async {
    await batch((batch) {
      batch.insertAll(movies, [...list]);
    });
  }
}
