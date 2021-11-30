import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InAppWebViewController? iawControlller;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController capChaController = TextEditingController();
  String textTransaction = "";
  bool loginIsVisible = true;
  double wvOpacity = 0;
  int stepLoading = 0;
  bool isEnableLogin = true;

  void _setTextTransaction(String text) {
    setState(() {
      textTransaction = text;
    });
  }

  void _setLoginVisible(bool state) {
    setState(() {
      loginIsVisible = state;
    });
  }

  void _setWvVisible(double value) {
    setState(() {
      wvOpacity = value;
    });
  }

  void _setEnableLogin(bool state) {
    setState(() {
      isEnableLogin = state;
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterDownloader.initialize();
  }

  Widget _dalkjfsdf(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 1,
          child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://vcbdigibank.vietcombank.com.vn")),
            onWebViewCreated: (InAppWebViewController controller) {
              iawControlller = controller;
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true, useOnDownloadStart: true),
            ),
            // onDownloadStart: (controller, uri) async {
            //   print("onDownloadStart $uri");
            //   final taskId = await FlutterDownloader.enqueue(
            //     url: "",
            //     savedDir: (await getExternalStorageDirectory())!.path,
            //     showNotification: true,
            //     openFileFromNotification: true,
            //   );
            // },
            onLoadStop: (InAppWebViewController controller, Uri? url) async {
              stepLoading++;
              print("loading onstop $url");
              if(stepLoading == 2) {
                iawControlller?.evaluateJavascript(source: "javascript:\$('#username').focus();");
                iawControlller?.evaluateJavascript(source: "javascript:\$('#app_password_login').focus();");
                iawControlller?.evaluateJavascript(source: "javascript:\$(\"input[name='captcha']\").focus();");
              }
              // if (stepLoading == 1) {
              //   _setEnableLogin(true);
              // }
              // if (stepLoading == 2) {
              //   _setLoginVisible(false);
              //   _setWvVisible(1);
              // }
              // if (stepLoading == 3) {
              //   await iawControlller?.evaluateJavascript(
              //       source:
              //           "javascript:document.getElementsByName('AI.QCK.ACCOUNT')[0].click()");
              // }
              // if (stepLoading == 4) {
              //   print("TRIEUVD: da vao man giao dich");
              //   await iawControlller?.evaluateJavascript(
              //       source:
              //       "javascript:\$(\"input[name='fieldName:START.DATE']\").val('01/09/2021');");
              //   await iawControlller?.evaluateJavascript(
              //       source:
              //       "javascript:\$(\"input[name='fieldName:END.DATE']\").val('01/11/2021');");
              // }
            },
          ),
        ),
        Visibility(
            visible: true,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextField(controller: userController),
                const SizedBox(
                  height: 50,
                ),
                TextField(controller: userController),
            const SizedBox(height: 10,),
            // Image.network(
            //            "https://vcbdigibank.vietcombank.com.vn/w1/get-captcha/ebefb08b-4eda-859d-4806-6d96b673619f"),
                Row(
                  children: [
                    Expanded(child: TextField(controller: capChaController),),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.network(
                        "https://vcbdigibank.vietcombank.com.vn/w1/get-captcha/ebefb08b-4eda-859d-4806-6d96b673619f"),
                  ],
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: !isEnableLogin
                        ? null
                        : () async {
                            iawControlller?.evaluateJavascript(
                                source:
                                    "javascript:\$('#username').val('0327093838');");
                            iawControlller?.evaluateJavascript(
                                source:
                                    "javascript:\$('#app_password_login').val('Hoilg123!');");
                            iawControlller?.evaluateJavascript(
                                source:
                                    "javascript:\$(\"input[name='captcha']\").val('${capChaController.text}');");
                            // await iawControlller?.evaluateJavascript(
                            //     source: "javascript:\$('#btnLogin').click();");
                          },
                    child: const Text("Login")),

                ElevatedButton(
                    onPressed: !isEnableLogin
                        ? null
                        : () async {
                      await iawControlller?.evaluateJavascript(
                          source: "javascript:\$('#btnLogin').click();");
                    },
                    child: const Text("fsdf")),
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _dalkjfsdf(context),
      ),
    );
  }
}
