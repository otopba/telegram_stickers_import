import 'package:flutter/foundation.dart';
import 'package:telegram_stickers_import/sticker.dart';
import 'package:telegram_stickers_import/sticker_data.dart';

/// A sticker set
class StickerSet {
  /// Creates new sticker set
  StickerSet({
    required this.software,
    required this.isAnimated,
    this.thumbnail,
    required this.stickers,
  });

  /// Factory from map
  factory StickerSet.fromMap(Map<String, dynamic> map) {
    return StickerSet(
      software: map["software"],
      isAnimated: map["isAnimated"],
      thumbnail: map["thumbnail"] == null
          ? null
          : StickerData.fromMap(map["thumbnail"]),
      stickers: (map["stickers"] as List<Map<String, dynamic>>)
          .map((it) => Sticker.fromMap(it))
          .toList(),
    );
  }

  /// A string value that specifies an identifier of the app using the importing library
  final String software;

  /// A boolean value that determines whether the sticker set consists of animated stickers
  final bool isAnimated;

  /// A thumbnail of the sticker set. iOS only
  final StickerData? thumbnail;

  /// A array of stickers
  final List<Sticker> stickers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerSet &&
          runtimeType == other.runtimeType &&
          software == other.software &&
          isAnimated == other.isAnimated &&
          thumbnail == other.thumbnail &&
          listEquals(stickers, other.stickers);

  @override
  int get hashCode =>
      software.hashCode ^
      isAnimated.hashCode ^
      thumbnail.hashCode ^
      stickers.hashCode;

  /// Creates map from object
  Map<String, dynamic> toMap() => {
        "software": software,
        "isAnimated": isAnimated,
        "thumbnail": thumbnail?.toMap(),
        "stickers": stickers.map((it) => it.toMap()).toList()
      };
}
