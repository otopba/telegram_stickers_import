package com.otopba.telegram_stickers_import

import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class TelegramStickersImportPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: FlutterActivity? = null
    private var binaryMessenger: BinaryMessenger? = null
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "telegram_stickers_import")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        if (binaryMessenger == null) return

        activity = binding.activity as FlutterActivity
//         channel = MethodChannel(binaryMessenger, "telegram_stickers_import")
//         channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        activity = null
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "import") {
            handleImport(call = call, result = result)
        } else {
            result.notImplemented()
        }
    }

    private fun handleImport(call: MethodCall, result: Result) {
        if (activity == null) result.error("1", "Activity is null", "")
        val activity = activity ?: return

        val stickerSet = StickerSet.fromMap(call.arguments as Map<String, Any>)

        val uris = ArrayList(stickerSet.stickers.map {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                FileProvider.getUriForFile(
                    activity,
                    "${activity.packageName}.provider",
                    File(it.data.path!!)
                )
            } else {
                Uri.fromFile(File(it.data.path!!))
            }
        })

        uris.forEach {
            activity.grantUriPermission(
                TELEGRAM_PACKAGE,
                it,
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        }

        val emojis = ArrayList(stickerSet.stickers.map {
            it.emojis.joinToString(separator = "")
        }.toList())

        val intent = Intent(CREATE_STICKER_PACK_ACTION)
        intent.putExtra(Intent.EXTRA_STREAM, uris)
        intent.putExtra(CREATE_STICKER_PACK_IMPORTER_EXTRA, stickerSet.software)
        intent.putExtra(CREATE_STICKER_PACK_EMOJIS_EXTRA, emojis)
        intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK
        if (stickerSet.isAnimated) {
            intent.type = "image/*"
        } else {
            intent.type = "application/x-tgsticker"
        }

        try {
            activity.startActivity(intent)
        } catch (e: Exception) {
            result.error("2", "error while import", e.toString())
            return
        }
        result.success("success")
    }

    private companion object {
        private const val TELEGRAM_PACKAGE = "org.telegram.messenger"
        private const val CREATE_STICKER_PACK_ACTION = "$TELEGRAM_PACKAGE.CREATE_STICKER_PACK"
        private const val CREATE_STICKER_PACK_EMOJIS_EXTRA = "STICKER_EMOJIS"
        private const val CREATE_STICKER_PACK_IMPORTER_EXTRA = "IMPORTER"
    }
}
