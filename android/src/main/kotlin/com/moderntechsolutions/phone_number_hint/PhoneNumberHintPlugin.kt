package com.moderntechsolutions.phone_number_hint

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.app.PendingIntent
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat.startIntentSenderForResult
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.credentials.Credential
import com.google.android.gms.auth.api.credentials.CredentialPickerConfig
import com.google.android.gms.auth.api.credentials.HintRequest.Builder
import com.google.android.gms.auth.api.identity.GetPhoneNumberHintIntentRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.common.api.GoogleApiClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener


/** PhoneNumberHintPlugin */
class PhoneNumberHintPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: MethodChannel.Result? = null
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "phone_number_hint")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, @NonNull result: Result) {
        pendingResult = result
        if (call.method == "requestHint") {

            val request: GetPhoneNumberHintIntentRequest = GetPhoneNumberHintIntentRequest.builder().build()
            Identity.getSignInClient(activity!!)
                .getPhoneNumberHintIntent(request)
                .addOnSuccessListener { result: PendingIntent ->
                    try {

                        startIntentSenderForResult(
                            activity!!, result.intentSender, HINT_REQUEST, null, 0, 0, 0, null
                        )
                    } catch (e: Exception) {
                        Log.e(PLUGIN_TAG, "Launching the PendingIntent failed")
                    }
                }
                .addOnFailureListener {
                    Log.e(PLUGIN_TAG, "Phone Number Hint failed")
                }

            return;
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    companion object {
        private const val PLUGIN_TAG = "PhoneNumberHintPlugin"
        private const val HINT_REQUEST = 11100
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.d(PLUGIN_TAG, "onActivityResult: requestCode: $requestCode")
        when (requestCode) {
            HINT_REQUEST -> onHintRequest(resultCode, data)
        }
        return true
    }

    private fun ignoreIllegalState(fn: () -> Unit) {
        try {
            fn()
        } catch (e: IllegalStateException) {
            Log.e(PLUGIN_TAG, "ignoring exception: $e")
        }
    }

    private fun onHintRequest(resultCode: Int, data: Intent?) {
        if (resultCode == RESULT_OK && data != null) {
            try {
                val phoneNumber = Identity.getSignInClient(activity!!).getPhoneNumberFromIntent(data)
                ignoreIllegalState { pendingResult?.success(phoneNumber) }
                return
            } catch (e: Exception) {
                ignoreIllegalState { pendingResult?.error("PHONE HINT FAILED", e.message, e) }
            }

        }

        ignoreIllegalState { pendingResult?.success(null) }
    }
}
