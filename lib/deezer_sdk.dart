import 'dart:async';
import 'dart:convert';

import 'package:deezer_sdk/models/auth_state.dart';
import 'package:deezer_sdk/typedef.dart';
import 'package:deezer_sdk/models/auth_credentials.dart';
import 'package:deezer_sdk/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
export 'package:deezer_sdk/typedef.dart';
export 'package:deezer_sdk/models/user.dart';

class DeezerSdk {
  static const MethodChannel _channel =
  const MethodChannel('deezer_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Initializes the plugin
  ///
  /// It receives a [appId] that is the applicationId
  /// that you can reclaim when you register your application
  /// on the Deezer Developers website [https://developers.deezer.com/]
  static initialize({ @required appId }) {
    _channel.invokeMethod("initialize", {
      "appId": appId
    });
  }

  /// Shows a webview for login with the Deezer credentials
  ///
  /// Can receive three callbacks [onComplete] will pass a [LoggedUser]
  /// object containing [AuthCredentials] and [User], that is the credentials
  /// and the user data
  /// The [onCancel] callback will be called when the user cancels the login
  /// Last, the [onError] callback will be called when any the some error
  /// to happen
  static login({
    LoggedUser onComplete,
    VoidCallback onCancel,
    Function(dynamic error) onError
  }) {
    _setupLoginCallbacks(
      onComplete: onComplete,
      onCancel: onCancel,
      onError: onError
    );

    _channel.invokeMethod("login");
  }

  /// Returns the current authentication state for user
  ///
  /// Will return [AuthState.AUTHENTICATED] if is authenticated
  /// otherwise returns [AuthState.UNAUTHENTICATED]
  static Future<AuthState> get authState async {
    final state = await _channel.invokeMethod("authState");

    if (state == "AUTHENTICATED") return AuthState.AUTHENTICATED;

    return AuthState.UNAUTHENTICATED;
  }

  static _setupLoginCallbacks({
    LoggedUser onComplete,
    VoidCallback onCancel,
    Function(dynamic error) onError
  }) {
    Future<void> platformCallHandler(MethodCall call) async {
      switch (call.method) {
        case 'onComplete':
          try {
            final user = User.fromJson(jsonDecode(call.arguments['user']));
            final credentials = AuthCredentials.fromJson({
              'access_token': call.arguments['access_token'],
              'expires': call.arguments['expires']
            });

            onComplete(credentials, user);
          } catch(e, s){
            print("$e $s");
          }
          break;
        case 'onCancel':
          onCancel();
          break;
        case 'onError':
          print("error ${call.arguments}");
          onError(call.arguments);
          break;
      }
    }

    _channel.setMethodCallHandler(platformCallHandler);
  }
}
