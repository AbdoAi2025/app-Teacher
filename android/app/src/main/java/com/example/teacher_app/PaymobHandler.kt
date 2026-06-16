package com.example.teacher_app

import android.content.ContextWrapper
import android.graphics.Color
import android.util.Log
import androidx.core.content.ContextCompat
import com.example.teacher_app.logPaymob
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.paymob.paymob_sdk.PaymobSdk
import com.paymob.paymob_sdk.ui.PaymobSdkListener
import io.flutter.embedding.engine.FlutterEngine

class PaymobHandler(
    private val activity: MainActivity,
    private val flutterEngine: FlutterEngine)  {

    fun initMethodChannel() {
        flutterEngine.dartExecutor.binaryMessenger.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "payWithPaymob") {
                    processPayment(call , result)
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    fun processPayment(call: MethodCall, result: MethodChannel.Result) {
        try {
            val appName = call.argument<String>("appName")
            val publicKey = call.argument<String>("publicKey")
            val clientSecret = call.argument<String>("clientSecret")
            val language = call.argument<String>("language") ?: "en"
            val buttonBackgroundColorData = call.argument<Number>("buttonBackgroundColor")?.toInt() ?: 0
            val buttonTextColorData = call.argument<Number>("buttonTextColor")?.toInt() ?: 0
            val saveCardDefault = call.argument<Boolean>("saveCardDefault") ?: false
            val showSaveCard = call.argument<Boolean>("showSaveCard") ?: true
            logPaymob("Current locale config: ${activity.resources.configuration.locales[0]}, Flutter language: $language")

            if (publicKey == null || clientSecret == null) {
                result.error("INVALID_ARGUMENTS", "Public key and client secret are required", null)
                return
            }

            val buttonBackgroundColor = if (buttonBackgroundColorData != 0) {
                Color.argb(
                    (buttonBackgroundColorData shr 24) and 0xFF,  // Alpha
                    (buttonBackgroundColorData shr 16) and 0xFF,  // Red
                    (buttonBackgroundColorData shr 8) and 0xFF,   // Green
                    buttonBackgroundColorData and 0xFF            // Blue
                )
            } else {
                Color.BLACK
            }

            val buttonTextColor = if (buttonTextColorData != 0) {
                Color.argb(
                    (buttonTextColorData shr 24) and 0xFF,  // Alpha
                    (buttonTextColorData shr 16) and 0xFF,  // Red
                    (buttonTextColorData shr 8) and 0xFF,   // Green
                    buttonTextColorData and 0xFF            // Blue
                )
            } else {
                Color.WHITE
            }

            logPaymob( "Processing payment with colors - Background: $buttonBackgroundColor, Text: $buttonTextColor")

            // Set callback URL for payment redirect
            val callbackUrl = "teacherassistant://payment"

            val paymobSdk = PaymobSdk.Builder(
                context = activity,
                clientSecret = clientSecret,
                publicKey = publicKey,
                paymobSdkListener = PaymobListener(result , { activity.onBackPressed() }),
                ).setButtonBackgroundColor(buttonBackgroundColor)
                .setButtonTextColor(buttonTextColor)
                .setAppName(appName)
//                .setAppLogo(R.mipmap.ic_launcher)
                .showSaveCard(showSaveCard)
                .saveCardByDefault(saveCardDefault)
                .build()

            paymobSdk.start()

        } catch (e: Exception) {
            logPaymob( "Error processing payment ${e.toString()}")
            result.error("PAYMENT_ERROR", "Failed to process payment: ${e.message}", null)
        }
    }

    companion object {
        private const val TAG = "PaymobHandler"
        private const  val CHANNEL = "paymob_sdk_flutter"
    }
}

class  PaymobListener(private val result: MethodChannel.Result , private val onBack: () -> Unit) : PaymobSdkListener{

    // PaymobSDK Callback Methods
    override fun onSuccess(payResponse: HashMap<String, String?>) {
        logPaymob( "Payment successful")
        result.success("Successful")
    }

    override fun onFailure(msg: String?) {
        logPaymob( "Payment failed")
        result.error("PAYMENT_FAILED",msg, null)
    }

    override fun onPending() {
        result.success("Pending")
    }
}

private fun logPaymob(msg: String){
    Log.e(" PaymobAndroid", msg)
}