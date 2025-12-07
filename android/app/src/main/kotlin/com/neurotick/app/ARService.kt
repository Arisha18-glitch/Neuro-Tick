package com.neurotick.app

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ARService : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ar_service")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkARCoreSupport" -> {
                val isSupported = isARCoreSupported()
                result.success(isSupported)
            }
            "openARCorePlayStore" -> {
                openPlayStoreForARCore()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun isARCoreSupported(): Boolean {
        return try {
            val packageManager = context.packageManager
            // Check if ARCore is installed
            packageManager.getApplicationInfo("com.google.ar.core", 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun openPlayStoreForARCore() {
        try {
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("market://details?id=com.google.ar.core")
                setPackage("com.android.vending")
            }
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
        } catch (e: Exception) {
            // If Play Store not available, open browser
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("https://play.google.com/store/apps/details?id=com.google.ar.core")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}