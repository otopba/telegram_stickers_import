import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telegram_stickers_import/sticker.dart';
import 'package:telegram_stickers_import/sticker_data.dart';
import 'package:telegram_stickers_import/sticker_set.dart';
import 'package:telegram_stickers_import/telegram_stickers_import.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _stickerNames = [
    'sticker1.webp',
    'sticker2.webp',
    'sticker3.webp',
    'sticker4.webp',
    'sticker5.webp',
    'sticker6.webp',
    'sticker7.webp',
    'sticker8.webp',
    'sticker9.webp'
  ];
  final _animatedStickerNames = [
    'a_sticker1.tgs',
    'a_sticker2.tgs',
    'a_sticker3.tgs',
    'a_sticker4.tgs',
    'a_sticker5.tgs',
    'a_sticker6.tgs',
    'a_sticker7.tgs',
    'a_sticker8.tgs',
    'a_sticker9.tgs',
  ];

  final Completer _assetsCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _copyAssets().then((value) => _assetsCompleter.complete());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(title: const Text('Plugin example app'));
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _importButton(),
          const SizedBox(height: 50),
          _importAnimatedButton(),
        ],
      ),
    );
  }

  Widget _importButton() {
    return ElevatedButton(
      onPressed: _onImportPressed,
      child: const Text("Import"),
    );
  }

  Widget _importAnimatedButton() {
    return ElevatedButton(
      onPressed: _onImportAnimatedPressed,
      child: const Text("Import animated"),
    );
  }

  Future<void> _onImportPressed() async {
    debugPrint("On import pressed");
    await _assetsCompleter.future;

    final stickers = [
      Sticker(
        emojis: ["☺️"],
        data: await _stickerData(_stickerNames[0]),
      ),
      Sticker(
        emojis: ["\uD83D\uDE22"],
        data: await _stickerData(_stickerNames[1]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD73"],
        data: await _stickerData(_stickerNames[2]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD2A"],
        data: await _stickerData(_stickerNames[3]),
      ),
      Sticker(
        emojis: ["\uD83D\uDE18️"],
        data: await _stickerData(_stickerNames[4]),
      ),
      Sticker(
        emojis: ["\uD83D\uDE18️"],
        data: await _stickerData(_stickerNames[5]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD2A"],
        data: await _stickerData(_stickerNames[6]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD73"],
        data: await _stickerData(_stickerNames[7]),
      ),
      Sticker(
        emojis: ["☺️"],
        data: await _stickerData(_stickerNames[8]),
      ),
    ];

    final set = StickerSet(
      software: "My app",
      isAnimated: false,
      stickers: stickers,
    );

    await TelegramStickersImport.import(set);
  }

  Future<void> _onImportAnimatedPressed() async {
    debugPrint("On import animated pressed");

    final stickers = [
      Sticker(
        emojis: ["☺️"],
        data: await _stickerData(_animatedStickerNames[0]),
      ),
      Sticker(
        emojis: ["\uD83D\uDE22"],
        data: await _stickerData(_animatedStickerNames[1]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD73"],
        data: await _stickerData(_animatedStickerNames[2]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD2A"],
        data: await _stickerData(_animatedStickerNames[3]),
      ),
      Sticker(
        emojis: ["\uD83D\uDE18️"],
        data: await _stickerData(_animatedStickerNames[4]),
      ),
      Sticker(
        emojis: ["\uD83D\uDE18️"],
        data: await _stickerData(_animatedStickerNames[5]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD2A"],
        data: await _stickerData(_animatedStickerNames[6]),
      ),
      Sticker(
        emojis: ["\uD83E\uDD73"],
        data: await _stickerData(_animatedStickerNames[7]),
      ),
      Sticker(
        emojis: ["☺️"],
        data: await _stickerData(_animatedStickerNames[8]),
      ),
    ];

    final set = StickerSet(
      software: "My app",
      isAnimated: true,
      stickers: stickers,
    );

    await TelegramStickersImport.import(set);
  }

  Future<void> _copyAssets() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final directory = await getTemporaryDirectory();
      final names = <String>{};
      names.addAll(_stickerNames);
      names.addAll(_animatedStickerNames);
      for (final name in names) {
        ByteData data = await rootBundle.load("assets/$name");
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        Directory(
          "${directory.path}/${TelegramStickersImport.androidImportFolderName}",
        ).createSync();
        await File(
          "${directory.path}/${TelegramStickersImport.androidImportFolderName}/$name",
        ).writeAsBytes(bytes);
      }
    }
  }

  Future<StickerData> _stickerData(String name) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final directory = await getTemporaryDirectory();
      return StickerData.android(
          "${directory.path}/${TelegramStickersImport.androidImportFolderName}/$name");
    } else {
      ByteData data = await rootBundle.load("assets/$name");
      return StickerData.iOS(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    }
  }
}
