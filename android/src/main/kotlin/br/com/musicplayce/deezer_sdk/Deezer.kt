package br.com.musicplayce.deezer_sdk

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log
import com.deezer.sdk.model.Permissions
import com.deezer.sdk.model.User
import com.deezer.sdk.network.connect.DeezerConnect
import com.deezer.sdk.network.connect.event.DialogListener
import com.deezer.sdk.network.request.DeezerRequestFactory
import com.deezer.sdk.network.request.event.JsonRequestListener
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class Deezer() {
    lateinit var channel: MethodChannel
    lateinit var activity: Activity
    private lateinit var dzrConnect: DeezerConnect
    private val TAG = "DEEZER_MUSICPLAYCE"
    private val permissions = arrayOf(
        Permissions.BASIC_ACCESS
    )
    private var authState: AuthState = AuthState.UNAUTHENTICATED

    fun initialize(appId: String, context: Context) {
        Log.d(TAG, "Deezer.Initialize")
        dzrConnect = DeezerConnect(context, appId)
    }

    val currentAuthState: AuthState
        get() = authState

    fun login() {
        dzrConnect.authorize(activity, permissions, object : DialogListener {
            override fun onComplete(data: Bundle?) {
                authState = if (dzrConnect.isSessionValid) {
                    AuthState.AUTHENTICATED
                } else AuthState.UNAUTHENTICATED

                lateinit var map : Map<String, Any>

                if (data != null) {
                    map = mapOf<String, Any>(
                        "access_token" to data.getString("access_token"),
                        "expires" to data.getString("expires"),
                        "user" to dzrConnect.currentUser.toJson().toString()
                    )
                }

                channel.invokeMethod("onComplete", map)
            }

            override fun onCancel() {
                authState = AuthState.UNAUTHENTICATED

                channel.invokeMethod("onCancel", null)
            }

            override fun onException(error: Exception?) {
                authState = AuthState.UNAUTHENTICATED

                Log.d(TAG, "ERROR $error")

                channel.invokeMethod("onError", error)
            }
        })
    }
}

class DeezerRequestListener(private val channel: MethodChannel) : JsonRequestListener() {
    override fun onResult(p0: Any?, p1: Any?) {
        channel.invokeMethod("onResult", p0)
    }

    override fun onUnparsedResult(p0: String?, p1: Any?) {
        channel.invokeMethod("onUnparsedResult", p0)
    }

    override fun onException(p0: Exception?, p1: Any?) {
        channel.invokeMethod("onException", p0)
    }
}

enum class AuthState {
    AUTHENTICATED,
    UNAUTHENTICATED
}