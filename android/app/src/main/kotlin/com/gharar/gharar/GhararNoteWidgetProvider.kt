package com.gharar.gharar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

/**
 * Home-screen widget showing the latest love note received on this device:
 * a handwritten drawing or photo when there is one, otherwise the note text.
 * Data is written from Dart by HomeWidgetService.
 */
class GhararNoteWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val sender = widgetData.getString(KEY_SENDER, null)
        val emoji = widgetData.getString(KEY_EMOJI, null) ?: "💌"
        val caption = widgetData.getString(KEY_CAPTION, null)
        val image = widgetData.getString(KEY_IMAGE_PATH, null)?.let(::decodeScaled)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.gharar_note_widget).apply {
                setTextViewText(R.id.note_emoji, emoji)
                setTextViewText(
                    R.id.note_sender,
                    sender ?: context.getString(R.string.widget_empty),
                )

                if (image != null) {
                    setImageViewBitmap(R.id.note_image, image)
                    setViewVisibility(R.id.note_image, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.note_image, View.GONE)
                }

                if (!caption.isNullOrBlank()) {
                    setTextViewText(R.id.note_caption, caption)
                    setViewVisibility(R.id.note_caption, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.note_caption, View.GONE)
                }

                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    /** Decodes [path] downsampled so the bitmap stays within RemoteViews limits. */
    private fun decodeScaled(path: String): Bitmap? {
        if (!File(path).exists()) return null
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        var sampleSize = 1
        while (bounds.outWidth / sampleSize > MAX_SIDE_PX || bounds.outHeight / sampleSize > MAX_SIDE_PX) {
            sampleSize *= 2
        }
        return BitmapFactory.decodeFile(path, BitmapFactory.Options().apply { inSampleSize = sampleSize })
    }

    private companion object {
        const val KEY_SENDER = "note_sender"
        const val KEY_EMOJI = "note_emoji"
        const val KEY_CAPTION = "note_caption"
        const val KEY_IMAGE_PATH = "note_image_path"
        const val MAX_SIDE_PX = 720
    }
}
