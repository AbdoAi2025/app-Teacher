package com.example.teacher_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private val whatsAppHelper = WhatsAppHelper()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        whatsAppHelper.initMethodChannel(this, flutterEngine)
        PaymobHandler(activity = this, flutterEngine = flutterEngine).initMethodChannel()
    }
}