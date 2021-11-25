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
  String textTransaction = "";
  bool loginIsVisible = true;
  double wvOpacity = 0;
  int stepLoading = 0;
  bool isEnableLogin = false;

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
          opacity: wvOpacity,
          child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://ib.techcombank.com.vn/servlet/BrowserServlet")),
            onWebViewCreated: (InAppWebViewController controller) {
              iawControlller = controller;
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                  useOnDownloadStart: true
              ),
            ),
            onDownloadStart: (controller, uri) async {
              print("onDownloadStart $uri");
              final taskId = await FlutterDownloader.enqueue(
                url: "",
                savedDir: (await getExternalStorageDirectory())!.path,
                showNotification: true,
                // show download progress in status bar (for Android)
                openFileFromNotification:
                    true, // click on notification to open downloaded file (for Android)
              );
            },
            onLoadStop: (InAppWebViewController controller, Uri? url) async {
              stepLoading++;
              print("loading onstop $stepLoading");
              if (stepLoading == 1) {
                _setEnableLogin(true);
              }
              if (stepLoading == 2) {
                _setLoginVisible(false);
                _setWvVisible(1);
              }
              if (stepLoading == 3) {
                await iawControlller?.evaluateJavascript(
                    source:
                        "javascript:document.getElementsByName('AI.QCK.ACCOUNT')[0].click()");
              }
              if (stepLoading == 4) {
                print("TRIEUVD: da vao man giao dich");
                await iawControlller?.evaluateJavascript(
                    source:
                    "javascript:\$(\"input[name='fieldName:START.DATE']\").val('01/09/2021');");
                await iawControlller?.evaluateJavascript(
                    source:
                    "javascript:\$(\"input[name='fieldName:END.DATE']\").val('01/11/2021');");
              }
            },
          ),
        ),
        Visibility(
            visible: loginIsVisible,
            child: Column(
              children: [
              const SizedBox(height: 50,),
                TextField(controller: userController),
                const SizedBox(
                  height: 50,
                ),
                TextField(controller: userController),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed: !isEnableLogin? null : () async {
                      iawControlller?.evaluateJavascript(
                          source:
                              "javascript:\$('#signOnName').val('01627093838');");
                      iawControlller?.evaluateJavascript(
                          source:
                              "javascript:\$('#password').val('Hoilg12!');");
                      iawControlller?.evaluateJavascript(
                          source:
                              "javascript:\$(\"form[name='login']\").submit();");
                    },
                    child: const Text("Login")),
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
