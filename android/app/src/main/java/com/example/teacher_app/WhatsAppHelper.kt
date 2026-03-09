package com.example.teacher_app

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class WhatsAppHelper {

    companion object {
        private const val CHANNEL = "whatsapp_share"
        private const val WHATSAPP_PACKAGE = "com.whatsapp"
        private const val WHATSAPP_BUSINESS_PACKAGE = "com.whatsapp.w4b"
        private const val WHATSAPP_DOMAIN = "@s.whatsapp.net"
    }

    fun initMethodChannel(context: Context, flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "sendFileToWhatsApp" -> {
                        val filePath: String? = call.argument("filePath")
                        val phone: String? = call.argument("phone")
                        if (filePath != null && phone != null) {
                            sendToWhatsApp(context, filePath, phone)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    }
                    "sendFileToWhatsAppBusiness" -> {
                        val filePath: String? = call.argument("filePath")
                        val phone: String? = call.argument("phone")
                        if (filePath != null && phone != null) {
                            sendToWhatsAppBusiness(context, filePath, phone)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    }
                    "isWhatsAppInstalled" -> {
                        result.success(isWhatsAppInstalled(context))
                    }
                    "isWhatsAppBusinessInstalled" -> {
                        result.success(isWhatsAppBusinessInstalled(context))
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.success(false)
            }
        }
    }

    fun sendToWhatsApp(context: Context, filePath: String, phone: String) {
        val file = File(filePath)
        val uri = getFileUri(context, file)

        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "*/*"
            setPackage(WHATSAPP_PACKAGE)
            putExtra(Intent.EXTRA_STREAM, uri)
            putExtra("jid", "$phone$WHATSAPP_DOMAIN")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        context.startActivity(intent)
    }

    fun sendToWhatsAppBusiness(context: Context, filePath: String, phone: String) {
        val file = File(filePath)
        val uri = getFileUri(context, file)

        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "*/*"
            setPackage(WHATSAPP_BUSINESS_PACKAGE)
            putExtra(Intent.EXTRA_STREAM, uri)
            putExtra("jid", "$phone$WHATSAPP_DOMAIN")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        context.startActivity(intent)
    }

    private fun getFileUri(context: Context, file: File): Uri {
        return FileProvider.getUriForFile(
            context,
            "${context.applicationContext.packageName}.provider",
            file
        )
    }

    fun isWhatsAppInstalled(context: Context): Boolean {
        return try {
            context.packageManager.getPackageInfo(WHATSAPP_PACKAGE, 0)
            true
        } catch (e: Exception) {
            false
        }
    }

    fun isWhatsAppBusinessInstalled(context: Context): Boolean {
        return try {
            context.packageManager.getPackageInfo(WHATSAPP_BUSINESS_PACKAGE, 0)
            true
        } catch (e: Exception) {
            false
        }
    }
}