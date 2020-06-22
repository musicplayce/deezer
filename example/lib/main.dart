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
                      _user = u;
                    });
                  },
                  onError: (error) => print("error $error"),
                  onCancel: () => print("Cancelled")
              );
            },
          ),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_user.name),
            Text(_user.firstname),
            Text(_user.lastname),
          ],
        ),
      ),
    );
  }
}