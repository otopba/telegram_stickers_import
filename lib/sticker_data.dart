import 'dart:typed_data';

/// Sticker data
class StickerData {
  /// Creates new sticker data
  StickerData({this.path, this.bytes});

  /// Android factory
  factory StickerData.android(String path) {
    return StickerData(path: path);
  }

  /// iOS factory
  factory StickerData.iOS(Uint8List bytes) {
    return StickerData(bytes: bytes);
  }

  /// Factory from map
  factory StickerData.fromMap(Map<String, dynamic> map) {
    return StickerData(path: map["path"], bytes: map["bytes"]);
  }

  /// The path to the sticker. Only for android
  final String? path;

  /// Data of the sticker. Only for iOS
  final Uint8List? bytes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerData &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          bytes == other.bytes;

  @override
  int get hashCode => path.hashCode ^ bytes.hashCode;

  /// Creates map from object
  Map<String, dynamic> toMap() => {
        "path": path,
        "bytes": bytes,
      };
}
