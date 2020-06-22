import 'package:deezer_sdk/models/auth_credentials.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:deezer_sdk/deezer_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User _user;
  AuthCredentials _credentials;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _user == null ? Center(
          child: FlatButton(
            child: Text("LOGIN"),
            onPressed: () {
              DeezerSdk.initialize(appId: "421042");
              print("state ${DeezerSdk.authState}");
              DeezerSdk.login(
                  onComplete: (c, u) async{
                    final s = await DeezerSdk.authState;
                    print("teste $s");
                    setState(() {
                      _credentials = c;
                      _user = u;
                    });
                  },
                  onError: (error) => print("error $error"),
                  onCancel: () => print("Cancelled")
              );
            },
          ),
        ) : Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                _user.pictureBig,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 5,),
              Text(_user.name),
              const SizedBox(height: 5,),
              Text(
                "Token: ${_credentials.accessToken}",
                textAlign: TextAlign.center
              )
            ],
          ),
        )
      ),
    );
  }
}