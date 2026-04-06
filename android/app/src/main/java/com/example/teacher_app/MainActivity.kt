package com.example.teacher_app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "payment_callback_channel"
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {

        val data: Uri? = intent?.data
        Log.d("MainActivity", "Payment callback received: $data")

        if (data != null && data.scheme == "teacherassistant" && data.host == "payment") {

            // Extract payment result parameters
            val transactionId = data.getQueryParameter("transaction_id")
            val status = data.getQueryParameter("status")
            val amount = data.getQueryParameter("amount")
            val currency = data.getQueryParameter("currency")
            val orderId = data.getQueryParameter("order_id")

            // Create result map
            val result = mapOf(
                "transaction_id" to transactionId,
                "status" to status,
                "amount" to amount,
                "currency" to currency,
                "order_id" to orderId,
                "success" to (status == "success" || status == "completed"),
                "callback_url" to data.toString()
            )

            // Send result to Flutter
            methodChannel?.invokeMethod("onPaymentCallback", result)

            Log.d("MainActivity", "Payment result sent to Flutter: $result")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize method channels
        WhatsAppHelper().initMethodChannel(this, flutterEngine)
        PaymobHandler(activity = this, flutterEngine = flutterEngine).initMethodChannel()

        // Setup payment callback channel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }
}