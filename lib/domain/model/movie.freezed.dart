// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MovieTearOff {
  const _$MovieTearOff();

  _Movie call(
      {int? id,
      String? thumbnailPath,
      String? moviePath,
      bool isFavorite = false,
      DateTime? swungAt}) {
    return _Movie(
      id: id,
      thumbnailPath: thumbnailPath,
      moviePath: moviePath,
      isFavorite: isFavorite,
      swungAt: swungAt,
    );
  }
}

/// @nodoc
const $Movie = _$MovieTearOff();

/// @nodoc
mixin _$Movie {
  int? get id => throw _privateConstructorUsedError;
  String? get thumbnailPath => throw _privateConstructorUsedError;
  String? get moviePath => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get swungAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MovieCopyWith<Movie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieCopyWith<$Res> {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) then) =
      _$MovieCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      String? thumbnailPath,
      String? moviePath,
      bool isFavorite,
      DateTime? swungAt});
}

/// @nodoc
class _$MovieCopyWithImpl<$Res> implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._value, this._then);

  final Movie _value;
  // ignore: unused_field
  final $Res Function(Movie) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? thumbnailPath = freezed,
    Object? moviePath = freezed,
    Object? isFavorite = freezed,
    Object? swungAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailPath: thumbnailPath == freezed
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      moviePath: moviePath == freezed
          ? _value.moviePath
          : moviePath // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: isFavorite == freezed
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      swungAt: swungAt == freezed
          ? _value.swungAt
          : swungAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
abstract class _$MovieCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$MovieCopyWith(_Movie value, $Res Function(_Movie) then) =
      __$MovieCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      String? thumbnailPath,
      String? moviePath,
      bool isFavorite,
      DateTime? swungAt});
}

/// @nodoc
class __$MovieCopyWithImpl<$Res> extends _$MovieCopyWithImpl<$Res>
    implements _$MovieCopyWith<$Res> {
  __$MovieCopyWithImpl(_Movie _value, $Res Function(_Movie) _then)
      : super(_value, (v) => _then(v as _Movie));

  @override
  _Movie get _value => super._value as _Movie;

  @override
  $Res call({
    Object? id = freezed,
    Object? thumbnailPath = freezed,
    Object? moviePath = freezed,
    Object? isFavorite = freezed,
    Object? swungAt = freezed,
  }) {
    return _then(_Movie(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailPath: thumbnailPath == freezed
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      moviePath: moviePath == freezed
          ? _value.moviePath
          : moviePath // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: isFavorite == freezed
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      swungAt: swungAt == freezed
          ? _value.swungAt
          : swungAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_Movie implements _Movie {
  const _$_Movie(
      {this.id,
      this.thumbnailPath,
      this.moviePath,
      this.isFavorite = false,
      this.swungAt});

  @override
  final int? id;
  @override
  final String? thumbnailPath;
  @override
  final String? moviePath;
  @JsonKey(defaultValue: false)
  @override
  final bool isFavorite;
  @override
  final DateTime? swungAt;

  @override
  String toString() {
    return 'Movie(id: $id, thumbnailPath: $thumbnailPath, moviePath: $moviePath, isFavorite: $isFavorite, swungAt: $swungAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Movie &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                const DeepCollectionEquality()
                    .equals(other.thumbnailPath, thumbnailPath)) &&
            (identical(other.moviePath, moviePath) ||
                const DeepCollectionEquality()
                    .equals(other.moviePath, moviePath)) &&
            (identical(other.isFavorite, isFavorite) ||
                const DeepCollectionEquality()
                    .equals(other.isFavorite, isFavorite)) &&
            (identical(other.swungAt, swungAt) ||
                const DeepCollectionEquality().equals(other.swungAt, swungAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(thumbnailPath) ^
      const DeepCollectionEquality().hash(moviePath) ^
      const DeepCollectionEquality().hash(isFavorite) ^
      const DeepCollectionEquality().hash(swungAt);

  @JsonKey(ignore: true)
  @override
  _$MovieCopyWith<_Movie> get copyWith =>
      __$MovieCopyWithImpl<_Movie>(this, _$identity);
}

abstract class _Movie implements Movie {
  const factory _Movie(
      {int? id,
      String? thumbnailPath,
      String? moviePath,
      bool isFavorite,
      DateTime? swungAt}) = _$_Movie;

  @override
  int? get id => throw _privateConstructorUsedError;
  @override
  String? get thumbnailPath => throw _privateConstructorUsedError;
  @override
  String? get moviePath => throw _privateConstructorUsedError;
  @override
  bool get isFavorite => throw _privateConstructorUsedError;
  @override
  DateTime? get swungAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MovieCopyWith<_Movie> get copyWith => throw _privateConstructorUsedError;
}
