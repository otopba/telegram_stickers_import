package com.otopba.telegram_stickers_import

/**
 * Sticker data
 */
@Suppress("ArrayInDataClass")
data class StickerData(val path: String?, val bytes: ByteArray?) {
    companion object {
        fun fromMap(map: Map<String, Any>) =
            StickerData(path = map["path"] as String?, bytes = map["bytes"] as ByteArray?)
    }
}