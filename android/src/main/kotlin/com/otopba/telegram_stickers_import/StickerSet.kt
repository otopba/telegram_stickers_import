package com.otopba.telegram_stickers_import

/**
 * Sticker set
 */
data class StickerSet(
    val software: String,
    val isAnimated: Boolean,
    val thumbnail: StickerData?,
    val stickers: List<Sticker>
) {
    companion object {
        fun fromMap(map: Map<String, Any>) =
            StickerSet(
                software = map["software"] as String,
                isAnimated = map["isAnimated"] as Boolean,
                thumbnail = if (map["thumbnail"] == null) null else StickerData.fromMap(map["thumbnail"] as Map<String, Any>),
                stickers = (map["stickers"] as List<Map<String, Any>>).map { Sticker.fromMap(it) }
            )
    }
}