package com.timetalk.timetalk

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "Ora_BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_LOCKED_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            "android.intent.action.QUICKBOOT_POWERON",
            "com.htc.intent.action.QUICKBOOT_POWERON" -> handleBootComplete(context)
        }
    }

    private fun handleBootComplete(context: Context) {
        try {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val serviceRunning = prefs.getBoolean("flutter.service_running", false)
            val intervalMinutes = prefs.getLong("flutter.intervalMinutes", 0L)

            if (serviceRunning && intervalMinutes > 0) {
                prefs.edit()
                    .putBoolean("flutter.boot_completed", true)
                    .putLong("flutter.boot_time", System.currentTimeMillis())
                    .apply()
                Log.d(TAG, "Boot flags set for Ora service restart")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Boot handler error: ${e.message}", e)
        }
    }
}
