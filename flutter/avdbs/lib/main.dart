import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /*home: MyHomePage(title: 'Flutter Demo Home Page'),*/
      routes: {
        '/': (BuildContext context) => MyWebViewPage(),
      },
    );
  }
}

class MyWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        url: 'https://www.avdbs.com/',
        clearCache: false,
        clearCookies: true,
        withJavascript: true,
        withLocalStorage: true,
        withLocalUrl: true,
        withZoom: true,
        appCacheEnabled: true,
        scrollBar: true,
        userAgent: 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36',
        //supportMultipleWindows: true,
        allowFileURLs: true,
        /*hidden: true,
        initialChild: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),*/
      ),
    );
  }
}
