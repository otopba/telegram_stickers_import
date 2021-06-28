package com.otopba.telegram_stickers_import

/**
 * Sticker
 */
data class Sticker(val emojis: List<String>, val data: StickerData) {
    companion object {
        fun fromMap(map: Map<String, Any>) =
            Sticker(
                emojis = map["emojis"] as List<String>,
                data = StickerData.fromMap(map["data"] as Map<String, Any>)
            )
    }
}