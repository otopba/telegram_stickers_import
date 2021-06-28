import 'package:flutter_test/flutter_test.dart';
import 'package:telegram_stickers_import/sticker.dart';
import 'package:telegram_stickers_import/sticker_data.dart';
import 'package:telegram_stickers_import/sticker_set.dart';

void main() {
  test('serialize-deserialize', () async {
    final data = StickerData.android("path");
    final sticker = Sticker(emojis: ["☺️"], data: data);
    final originalSet = StickerSet(
      software: "test",
      isAnimated: true,
      stickers: [sticker],
    );
    final fromMap = StickerSet.fromMap(originalSet.toMap());

    expect(originalSet, fromMap);
  });
}
