import 'dart:async';

import 'package:flutter/services.dart';
import 'package:telegram_stickers_import/sticker_set.dart';

/// Android:
///
/// For creating sticker data you should use [StickerData.android] method
///
/// To import stickers from android, you need to build the correct path to the
/// files. The easiest way is to put the necessary files into the cache
/// directory in the [telegram_stickers_import] folder.
///
/// You can get the path to the cache folder by calling
/// [getTemporaryDirectory()] method of https://pub.dev/packages/path_provider
/// plugin. After that, just add stickers files to the
/// [telegram_stickers_import]` folder inside cache directory.
/// All the necessary settings for this folder have already been made by the
/// plugin, and the Telegram will be able to receive your stickers without any
/// problems.
///
/// In case if you want to use other paths, be sure to check out how to share
/// files between applications correctly:
/// https://developer.android.com/training/secure-file-sharing/setup-sharing
///
///iOS
///
/// For creating sticker data you should use [StickerData.iOS] method
///
/// To import stickers from the iOS application, you just need to write the
/// sticker content to [Uint8List]
class TelegramStickersImport {
  /// Folder inside cache directory for store your stickers
  static const androidImportFolderName = "telegram_stickers_import";

  static const MethodChannel _channel = MethodChannel(
    'telegram_stickers_import',
  );

  /// Method for import sticker set
  static Future<String?> import(StickerSet stickerSet) async {
    return _channel.invokeMethod('import', stickerSet.toMap());
  }
}
