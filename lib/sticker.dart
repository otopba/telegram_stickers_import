import 'package:flutter/foundation.dart';
import 'package:telegram_stickers_import/sticker_data.dart';

/// A sticker
class Sticker {
  /// Creates new sticker
  Sticker({
    required this.emojis,
    required this.data,
  });

  /// Factory from map
  factory Sticker.fromMap(Map<String, dynamic> map) {
    return Sticker(
      emojis: map["emojis"],
      data: StickerData.fromMap(map["data"]),
    );
  }

  /// Associated emojis of the sticker
  final List<String> emojis;

  /// Data of the sticker
  final StickerData data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sticker &&
          runtimeType == other.runtimeType &&
          listEquals(emojis, other.emojis) &&
          data == other.data;

  @override
  int get hashCode => emojis.hashCode ^ data.hashCode;

  /// Creates map from object
  Map<String, dynamic> toMap() => {
        "emojis": emojis,
        "data": data.toMap(),
      };
}
