// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Movie extends DataClass implements Insertable<Movie> {
  final int id;
  final String thumbnailPath;
  final String moviePath;
  final bool isFavorite;
  final bool isRead;
  final DateTime? swungAt;
  final String club;
  Movie(
      {required this.id,
      required this.thumbnailPath,
      required this.moviePath,
      required this.isFavorite,
      required this.isRead,
      this.swungAt,
      required this.club});
  factory Movie.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Movie(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      thumbnailPath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnail_path'])!,
      moviePath: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movie_path'])!,
      isFavorite: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_favorite'])!,
      isRead: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_read'])!,
      swungAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}swung_at']),
      club: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}club'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['thumbnail_path'] = Variable<String>(thumbnailPath);
    map['movie_path'] = Variable<String>(moviePath);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_read'] = Variable<bool>(isRead);
    if (!nullToAbsent || swungAt != null) {
      map['swung_at'] = Variable<DateTime?>(swungAt);
    }
    map['club'] = Variable<String>(club);
    return map;
  }

  MoviesCompanion toCompanion(bool nullToAbsent) {
    return MoviesCompanion(
      id: Value(id),
      thumbnailPath: Value(thumbnailPath),
      moviePath: Value(moviePath),
      isFavorite: Value(isFavorite),
      isRead: Value(isRead),
      swungAt: swungAt == null && nullToAbsent
          ? const Value.absent()
          : Value(swungAt),
      club: Value(club),
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Movie(
      id: serializer.fromJson<int>(json['id']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      moviePath: serializer.fromJson<String>(json['moviePath']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      swungAt: serializer.fromJson<DateTime?>(json['swungAt']),
      club: serializer.fromJson<String>(json['club']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'moviePath': serializer.toJson<String>(moviePath),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isRead': serializer.toJson<bool>(isRead),
      'swungAt': serializer.toJson<DateTime?>(swungAt),
      'club': serializer.toJson<String>(club),
    };
  }

  Movie copyWith(
          {int? id,
          String? thumbnailPath,
          String? moviePath,
          bool? isFavorite,
          bool? isRead,
          DateTime? swungAt,
          String? club}) =>
      Movie(
        id: id ?? this.id,
        thumbnailPath: thumbnailPath ?? this.thumbnailPath,
        moviePath: moviePath ?? this.moviePath,
        isFavorite: isFavorite ?? this.isFavorite,
        isRead: isRead ?? this.isRead,
        swungAt: swungAt ?? this.swungAt,
        club: club ?? this.club,
      );
  @override
  String toString() {
    return (StringBuffer('Movie(')
          ..write('id: $id, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('moviePath: $moviePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isRead: $isRead, ')
          ..write('swungAt: $swungAt, ')
          ..write('club: $club')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          thumbnailPath.hashCode,
          $mrjc(
              moviePath.hashCode,
              $mrjc(
                  isFavorite.hashCode,
                  $mrjc(isRead.hashCode,
                      $mrjc(swungAt.hashCode, club.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movie &&
          other.id == this.id &&
          other.thumbnailPath == this.thumbnailPath &&
          other.moviePath == this.moviePath &&
          other.isFavorite == this.isFavorite &&
          other.isRead == this.isRead &&
          other.swungAt == this.swungAt &&
          other.club == this.club);
}

class MoviesCompanion extends UpdateCompanion<Movie> {
  final Value<int> id;
  final Value<String> thumbnailPath;
  final Value<String> moviePath;
  final Value<bool> isFavorite;
  final Value<bool> isRead;
  final Value<DateTime?> swungAt;
  final Value<String> club;
  const MoviesCompanion({
    this.id = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.moviePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isRead = const Value.absent(),
    this.swungAt = const Value.absent(),
    this.club = const Value.absent(),
  });
  MoviesCompanion.insert({
    this.id = const Value.absent(),
    required String thumbnailPath,
    required String moviePath,
    this.isFavorite = const Value.absent(),
    this.isRead = const Value.absent(),
    this.swungAt = const Value.absent(),
    this.club = const Value.absent(),
  })  : thumbnailPath = Value(thumbnailPath),
        moviePath = Value(moviePath);
  static Insertable<Movie> custom({
    Expression<int>? id,
    Expression<String>? thumbnailPath,
    Expression<String>? moviePath,
    Expression<bool>? isFavorite,
    Expression<bool>? isRead,
    Expression<DateTime?>? swungAt,
    Expression<String>? club,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (moviePath != null) 'movie_path': moviePath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isRead != null) 'is_read': isRead,
      if (swungAt != null) 'swung_at': swungAt,
      if (club != null) 'club': club,
    });
  }

  MoviesCompanion copyWith(
      {Value<int>? id,
      Value<String>? thumbnailPath,
      Value<String>? moviePath,
      Value<bool>? isFavorite,
      Value<bool>? isRead,
      Value<DateTime?>? swungAt,
      Value<String>? club}) {
    return MoviesCompanion(
      id: id ?? this.id,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      moviePath: moviePath ?? this.moviePath,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
      swungAt: swungAt ?? this.swungAt,
      club: club ?? this.club,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (swungAt.present) {
      map['swung_at'] = Variable<DateTime?>(swungAt.value);
    }
    if (club.present) {
      map['club'] = Variable<String>(club.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesCompanion(')
          ..write('id: $id, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('moviePath: $moviePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isRead: $isRead, ')
          ..write('swungAt: $swungAt, ')
          ..write('club: $club')
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
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_favorite IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  late final GeneratedColumn<bool?> isRead = GeneratedColumn<bool?>(
      'is_read', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_read IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _swungAtMeta = const VerificationMeta('swungAt');
  late final GeneratedColumn<DateTime?> swungAt = GeneratedColumn<DateTime?>(
      'swung_at', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _clubMeta = const VerificationMeta('club');
  late final GeneratedColumn<String?> club = GeneratedColumn<String?>(
      'club', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, thumbnailPath, moviePath, isFavorite, isRead, swungAt, club];
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
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('swung_at')) {
      context.handle(_swungAtMeta,
          swungAt.isAcceptableOrUnknown(data['swung_at']!, _swungAtMeta));
    }
    if (data.containsKey('club')) {
      context.handle(
          _clubMeta, club.isAcceptableOrUnknown(data['club']!, _clubMeta));
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
