# TelegramStickersImport — Telegram stickers importing Flutter plugin for iOS and Android

[![pub package](https://img.shields.io/pub/v/telegram_stickers_import.svg)](https://pub.dev/packages/telegram_stickers_import)
 
TelegramStickersImport helps your users import third-party programmatically created sticker sets into Telegram Messenger for iOS and Android.

This is not an official plugin!

Please read the full documentation here: https://core.telegram.org/import-stickers

>**WARNING:** Each time a user imports stickers, a **new sticker pack** is created on Telegram. **Do not use** the importing feature to share stickers *you* made with *other* users. If you want to share your stickers, simply upload them using [@stickers](https://t.me/stickers), then share the **link** of your pack. For example, here's a link to install some [Duck Stickers](https://t.me/addstickers/svobodny).
 
### Installation

Add `telegram_stickers_import` dependency to your pubspec.yaml

#### Android

No special installation required
 
#### iOS

Configure your `Info.plist` by right-clicking it in Project Navigator, choosing **Open As > Source Code** and adding this snippet:  
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>tg</string>
</array>
```
 
### Usage

To import a sticker set into Telegram, create a new sticker set and import it as follows:  
```dart
final stickerSet = StickerSet(
    software: "My app",
    isAnimated: true,
    stickers: stickers,
);

TelegramStickersImport.import(stickerSet);
```

#### Android

> For creating sticker data you should use `StickerData.android` method

To import stickers from android, you need to build the correct path to the files. The easiest way is to put the necessary files into the cache directory in the `telegram_stickers_import` folder.

You can get the path to the cache folder by calling `getTemporaryDirectory()` method of [path_provider](https://pub.dev/packages/path_provider) plugin. After that, just add stickers files to the `telegram_stickers_import` folder inside cache directory.

All the necessary settings for this folder have already been made by the plugin, and the Telegram will be able to receive your stickers without any problems.
  
In case if you want to use other paths, be sure to check out how to share files between applications correctly: https://developer.android.com/training/secure-file-sharing/setup-sharing

#### iOS

> For creating sticker data you should use `StickerData.iOS` method

To import stickers from the iOS application, you just need to write the sticker content to Uint8List

### Official repositories

- [iOS](https://github.com/TelegramMessenger/TelegramStickersImport)
- [Android](https://github.com/DrKLO/TelegramStickersImport)