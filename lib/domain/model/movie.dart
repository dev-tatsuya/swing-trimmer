import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swing_trimmer/domain/model/club.dart';

part 'movie.freezed.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    int? id,
    String? thumbnailPath,
    String? moviePath,
    @Default(false) bool isFavorite,
    @Default(false) bool isRead,
    DateTime? swungAt,
    Club? club,
  }) = _Movie;
}
