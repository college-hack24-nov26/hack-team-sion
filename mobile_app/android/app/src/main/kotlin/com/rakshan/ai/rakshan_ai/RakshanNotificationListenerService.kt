package com.rakshan.ai.rakshan_ai

import android.app.Notification
import android.content.Intent
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import org.json.JSONObject
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

class RakshanNotificationListenerService : NotificationListenerService() {

    companion object {
        private const val TAG = "RakshanNotifService"
        var notificationCallback: ((Map<String, Any?>) -> Unit)? = null
        var isServiceConnected: Boolean = false
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        isServiceConnected = true
        Log.i(TAG, "Rakshan Notification Interceptor successfully connected to Android System.")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        isServiceConnected = false
        Log.w(TAG, "Rakshan Notification Interceptor disconnected.")
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        if (sbn == null) return

        val pkgName = sbn.packageName ?: return

        // Ignore our own notifications and system internal noise
        if (pkgName == packageName) return
        if (pkgName == "android" || pkgName == "com.android.systemui") return

        val extras = sbn.notification?.extras ?: return
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
            ?: extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
            ?: ""

        if (text.isBlank()) return

        val readableApp = getReadableAppName(pkgName)
        Log.i(TAG, "🚀 REAL-TIME NOTIFICATION CAPTURED: [$readableApp ($pkgName)] $title: $text")

        val payload = mapOf(
            "package_name" to pkgName,
            "app_name" to readableApp,
            "sender" to (if (title.isBlank()) "Unknown Contact" else title),
            "text_content" to text,
            "timestamp" to System.currentTimeMillis()
        )

        // 1. Send to active Flutter UI thread
        notificationCallback?.invoke(payload)

        // 2. Transmit to Python Multi-Agent Backend in background thread
        thread {
            val endpoints = listOf("http://127.0.0.1:8000/api/v1/monitor/ingest", "http://192.168.1.231:8000/api/v1/monitor/ingest")
            for (ep in endpoints) {
                try {
                    val url = URL(ep)
                    val conn = url.openConnection() as HttpURLConnection
                    conn.requestMethod = "POST"
                    conn.setRequestProperty("Content-Type", "application/json; utf-8")
                    conn.setRequestProperty("Accept", "application/json")
                    conn.doOutput = true
                    conn.connectTimeout = 1500
                    conn.readTimeout = 2500

                    val json = JSONObject()
                    json.put("device_id", "DEV-AARAV-SAMSUNG-S23")
                    json.put("app_name", readableApp)
                    json.put("package_name", pkgName)
                    json.put("sender", if (title.isBlank()) "Unknown Contact" else title)
                    json.put("text_content", text)
                    json.put("context_type", "incoming_notification")

                    val writer = OutputStreamWriter(conn.outputStream)
                    writer.write(json.toString())
                    writer.flush()
                    writer.close()

                    val code = conn.responseCode
                    Log.d(TAG, "Sent notification to $ep -> HTTP $code")
                    if (code == 200) break
                } catch (e: Exception) {
                    Log.w(TAG, "Failed to reach $ep: ${e.message}")
                }
            }
        }
    }

    private fun getReadableAppName(pkg: String): String {
        val lower = pkg.lowercase()
        return when {
            lower.contains("whatsapp") -> "WhatsApp"
            lower.contains("instagram") -> "Instagram DM"
            lower.contains("discord") -> "Discord"
            lower.contains("telegram") -> "Telegram"
            lower.contains("snapchat") -> "Snapchat"
            lower.contains("roblox") -> "Roblox"
            lower.contains("pubg") || lower.contains("imobile") -> "BGMI"
            lower.contains("freefire") -> "Free Fire"
            lower.contains("mms") || lower.contains("messaging") || lower.contains("sms") -> "SMS"
            lower.contains("chrome") -> "Chrome"
            lower.contains("youtube") -> "YouTube"
            else -> {
                try {
                    val appInfo = packageManager.getApplicationInfo(pkg, 0)
                    packageManager.getApplicationLabel(appInfo).toString()
                } catch (e: Exception) {
                    pkg
                }
            }
        }
    }
}
