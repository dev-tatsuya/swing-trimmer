// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'movie_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MovieListStateTearOff {
  const _$MovieListStateTearOff();

  _MovieListState call({Map<DateTime?, List<Movie>> moviesMap = const {}}) {
    return _MovieListState(
      moviesMap: moviesMap,
    );
  }
}

/// @nodoc
const $MovieListState = _$MovieListStateTearOff();

/// @nodoc
mixin _$MovieListState {
  Map<DateTime?, List<Movie>> get moviesMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MovieListStateCopyWith<MovieListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieListStateCopyWith<$Res> {
  factory $MovieListStateCopyWith(
          MovieListState value, $Res Function(MovieListState) then) =
      _$MovieListStateCopyWithImpl<$Res>;
  $Res call({Map<DateTime?, List<Movie>> moviesMap});
}

/// @nodoc
class _$MovieListStateCopyWithImpl<$Res>
    implements $MovieListStateCopyWith<$Res> {
  _$MovieListStateCopyWithImpl(this._value, this._then);

  final MovieListState _value;
  // ignore: unused_field
  final $Res Function(MovieListState) _then;

  @override
  $Res call({
    Object? moviesMap = freezed,
  }) {
    return _then(_value.copyWith(
      moviesMap: moviesMap == freezed
          ? _value.moviesMap
          : moviesMap // ignore: cast_nullable_to_non_nullable
              as Map<DateTime?, List<Movie>>,
    ));
  }
}

/// @nodoc
abstract class _$MovieListStateCopyWith<$Res>
    implements $MovieListStateCopyWith<$Res> {
  factory _$MovieListStateCopyWith(
          _MovieListState value, $Res Function(_MovieListState) then) =
      __$MovieListStateCopyWithImpl<$Res>;
  @override
  $Res call({Map<DateTime?, List<Movie>> moviesMap});
}

/// @nodoc
class __$MovieListStateCopyWithImpl<$Res>
    extends _$MovieListStateCopyWithImpl<$Res>
    implements _$MovieListStateCopyWith<$Res> {
  __$MovieListStateCopyWithImpl(
      _MovieListState _value, $Res Function(_MovieListState) _then)
      : super(_value, (v) => _then(v as _MovieListState));

  @override
  _MovieListState get _value => super._value as _MovieListState;

  @override
  $Res call({
    Object? moviesMap = freezed,
  }) {
    return _then(_MovieListState(
      moviesMap: moviesMap == freezed
          ? _value.moviesMap
          : moviesMap // ignore: cast_nullable_to_non_nullable
              as Map<DateTime?, List<Movie>>,
    ));
  }
}

/// @nodoc

class _$_MovieListState implements _MovieListState {
  const _$_MovieListState({this.moviesMap = const {}});

  @JsonKey(defaultValue: const {})
  @override
  final Map<DateTime?, List<Movie>> moviesMap;

  @override
  String toString() {
    return 'MovieListState(moviesMap: $moviesMap)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MovieListState &&
            (identical(other.moviesMap, moviesMap) ||
                const DeepCollectionEquality()
                    .equals(other.moviesMap, moviesMap)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(moviesMap);

  @JsonKey(ignore: true)
  @override
  _$MovieListStateCopyWith<_MovieListState> get copyWith =>
      __$MovieListStateCopyWithImpl<_MovieListState>(this, _$identity);
}

abstract class _MovieListState implements MovieListState {
  const factory _MovieListState({Map<DateTime?, List<Movie>> moviesMap}) =
      _$_MovieListState;

  @override
  Map<DateTime?, List<Movie>> get moviesMap =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MovieListStateCopyWith<_MovieListState> get copyWith =>
      throw _privateConstructorUsedError;
}
