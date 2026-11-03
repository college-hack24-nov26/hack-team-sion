package com.rakshan.ai.rakshan_ai

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.rakshan.ai/interceptor"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkNotificationPermission" -> {
                    val isGranted = isNotificationServiceEnabled()
                    result.success(isGranted)
                }

                "requestNotificationPermission" -> {
                    try {
                        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.message, null)
                    }
                }

                "getInstalledApps" -> {
                    try {
                        val apps = getInstalledAppsList()
                        result.success(apps)
                    } catch (e: Exception) {
                        result.error("GET_APPS_ERROR", e.message, null)
                    }
                }

                "sendTestNotification" -> {
                    val title = call.argument<String>("title") ?: "Instagram DM"
                    val message = call.argument<String>("message") ?: "Don't tell your mom about our chat. Send me a private selfie now."
                    val appName = call.argument<String>("app_name") ?: "Instagram"
                    val success = postLocalTestNotification(appName, title, message)
                    result.success(success)
                }

                else -> result.notImplemented()
            }
        }

        // Connect real-time callback from RakshanNotificationListenerService to Flutter
        RakshanNotificationListenerService.notificationCallback = { payload ->
            runOnUiThread {
                methodChannel?.invokeMethod("onNotificationReceived", payload)
            }
        }
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val pkgName = packageName
        val flat = Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
        return flat != null && flat.contains(pkgName)
    }

    private fun getInstalledAppsList(): List<Map<String, Any>> {
        val pm = packageManager
        val packages = pm.getInstalledPackages(PackageManager.GET_META_DATA)
        val list = mutableListOf<Map<String, Any>>()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            val appName = appInfo.loadLabel(pm).toString()
            val packageName = pkg.packageName

            // We include user-installed apps and major known communication/gaming apps
            list.add(
                mapOf(
                    "app_name" to appName,
                    "package_name" to packageName,
                    "is_system" to isSystemApp
                )
            )
        }
        return list
    }

    private fun postLocalTestNotification(appCategory: String, title: String, text: String): Boolean {
        return try {
            val channelId = "rakshan_simulated_alerts"
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    channelId,
                    "Incoming Cyber Simulation Channel",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Used to simulate incoming suspicious chat notifications"
                    enableVibration(true)
                }
                notificationManager.createNotificationChannel(channel)
            }

            val builder = NotificationCompat.Builder(this, channelId)
                .setSmallIcon(android.R.drawable.stat_notify_chat)
                .setContentTitle(title)
                .setContentText(text)
                .setStyle(NotificationCompat.BigTextStyle().bigText(text))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)

            notificationManager.notify((System.currentTimeMillis() % 100000).toInt(), builder.build())
            true
        } catch (e: Exception) {
            false
        }
    }
}
