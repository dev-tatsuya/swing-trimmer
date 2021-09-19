// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Movie extends DataClass implements Insertable<Movie> {
  final int id;
  final String title;
  final String thumbnailPath;
  final String moviePath;
  final bool isFavorite;
  final DateTime swungAt;
  Movie(
      {required this.id,
      required this.title,
      required this.thumbnailPath,
      required this.moviePath,
      required this.isFavorite,
      required this.swungAt});
  factory Movie.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Movie(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      thumbnailPath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_path'])!,
      moviePath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movie_path'])!,
      isFavorite: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_favorite'])!,
      swungAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}swung_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['thumbnail_path'] = Variable<String>(thumbnailPath);
    map['movie_path'] = Variable<String>(moviePath);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['swung_at'] = Variable<DateTime>(swungAt);
    return map;
  }

  MoviesCompanion toCompanion(bool nullToAbsent) {
    return MoviesCompanion(
      id: Value(id),
      title: Value(title),
      thumbnailPath: Value(thumbnailPath),
      moviePath: Value(moviePath),
      isFavorite: Value(isFavorite),
      swungAt: Value(swungAt),
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Movie(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      moviePath: serializer.fromJson<String>(json['moviePath']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      swungAt: serializer.fromJson<DateTime>(json['swungAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'moviePath': serializer.toJson<String>(moviePath),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'swungAt': serializer.toJson<DateTime>(swungAt),
    };
  }

  Movie copyWith(
          {int? id,
          String? title,
          String? thumbnailPath,
          String? moviePath,
          bool? isFavorite,
          DateTime? swungAt}) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        thumbnailPath: thumbnailPath ?? this.thumbnailPath,
        moviePath: moviePath ?? this.moviePath,
        isFavorite: isFavorite ?? this.isFavorite,
        swungAt: swungAt ?? this.swungAt,
      );
  @override
  String toString() {
    return (StringBuffer('Movie(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('moviePath: $moviePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('swungAt: $swungAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              thumbnailPath.hashCode,
              $mrjc(moviePath.hashCode,
                  $mrjc(isFavorite.hashCode, swungAt.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movie &&
          other.id == this.id &&
          other.title == this.title &&
          other.thumbnailPath == this.thumbnailPath &&
          other.moviePath == this.moviePath &&
          other.isFavorite == this.isFavorite &&
          other.swungAt == this.swungAt);
}

class MoviesCompanion extends UpdateCompanion<Movie> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> thumbnailPath;
  final Value<String> moviePath;
  final Value<bool> isFavorite;
  final Value<DateTime> swungAt;
  const MoviesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.moviePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.swungAt = const Value.absent(),
  });
  MoviesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String thumbnailPath,
    required String moviePath,
    required bool isFavorite,
    required DateTime swungAt,
  })  : title = Value(title),
        thumbnailPath = Value(thumbnailPath),
        moviePath = Value(moviePath),
        isFavorite = Value(isFavorite),
        swungAt = Value(swungAt);
  static Insertable<Movie> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? thumbnailPath,
    Expression<String>? moviePath,
    Expression<bool>? isFavorite,
    Expression<DateTime>? swungAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (moviePath != null) 'movie_path': moviePath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (swungAt != null) 'swung_at': swungAt,
    });
  }

  MoviesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? thumbnailPath,
      Value<String>? moviePath,
      Value<bool>? isFavorite,
      Value<DateTime>? swungAt}) {
    return MoviesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      moviePath: moviePath ?? this.moviePath,
      isFavorite: isFavorite ?? this.isFavorite,
      swungAt: swungAt ?? this.swungAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (moviePath.present) {
      map['movie_path'] = Variable<String>(moviePath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (swungAt.present) {
      map['swung_at'] = Variable<DateTime>(swungAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('moviePath: $moviePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('swungAt: $swungAt')
          ..write(')'))
        .toString();
  }
}

class $MoviesTable extends Movies with TableInfo<$MoviesTable, Movie> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MoviesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _thumbnailPathMeta =
      const VerificationMeta('thumbnailPath');
  late final GeneratedColumn<String?> thumbnailPath = GeneratedColumn<String?>(
      'thumbnail_path', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _moviePathMeta = const VerificationMeta('moviePath');
  late final GeneratedColumn<String?> moviePath = GeneratedColumn<String?>(
      'movie_path', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
  late final GeneratedColumn<bool?> isFavorite = GeneratedColumn<bool?>(
      'is_favorite', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_favorite IN (0, 1))');
  final VerificationMeta _swungAtMeta = const VerificationMeta('swungAt');
  late final GeneratedColumn<DateTime?> swungAt = GeneratedColumn<DateTime?>(
      'swung_at', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, thumbnailPath, moviePath, isFavorite, swungAt];
  @override
  String get aliasedName => _alias ?? 'movies';
  @override
  String get actualTableName => 'movies';
  @override
  VerificationContext validateIntegrity(Insertable<Movie> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableOrUnknown(
              data['thumbnail_path']!, _thumbnailPathMeta));
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (data.containsKey('movie_path')) {
      context.handle(_moviePathMeta,
          moviePath.isAcceptableOrUnknown(data['movie_path']!, _moviePathMeta));
    } else if (isInserting) {
      context.missing(_moviePathMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    } else if (isInserting) {
      context.missing(_isFavoriteMeta);
    }
    if (data.containsKey('swung_at')) {
      context.handle(_swungAtMeta,
          swungAt.isAcceptableOrUnknown(data['swung_at']!, _swungAtMeta));
    } else if (isInserting) {
      context.missing(_swungAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movie map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Movie.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MoviesTable createAlias(String alias) {
    return $MoviesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $MoviesTable movies = $MoviesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [movies];
}
