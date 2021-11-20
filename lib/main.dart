import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';

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
  int getTransactionStep = 0;

  void _setTextTransaction(String text) {
    setState(() {
      textTransaction = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "https://ib.techcombank.com.vn/servlet/BrowserServlet")),
                onWebViewCreated: (InAppWebViewController controller) {
                  iawControlller = controller;
                },

                onLoadStop: (InAppWebViewController controller, Uri? url) async {
                  print("get step $getTransactionStep");
                  if(getTransactionStep == 0) {
                    await iawControlller?.evaluateJavascript(
                        source:
                        "javascript:document.getElementsByName('AI.QCK.ACCOUNT')[0].click()");
                    getTransactionStep++;
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(textTransaction),
            const SizedBox(
              height: 100,
            ),
            TextField(controller: userController),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: passController,
              autofocus: false,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
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
                ElevatedButton(
                    onPressed: () async {
                      iawControlller?.evaluateJavascript(
                          source:
                              "javascript:document.getElementsByName('AI.QCK.ACCOUNT')[0].click()");
                    },
                    child: const Text("chuyển tab tk")),
                ElevatedButton(
                    onPressed: () async {
                      //await iawControlller?.evaluateJavascript(source: "javascript:\$(\"table[id='goButton']:eq(1) a[title='Xem giao dịch']\").click();");
                      iawControlller?.evaluateJavascript(source: "javascript:\$(\"input[name='fieldName:START.DATE']\").val('01/09/2021');");
                      iawControlller?.evaluateJavascript(source: "javascript:\$(\"input[name='fieldName:END.DATE']\").val('01/11/2021');");
                      iawControlller?.evaluateJavascript(source: "javascript:\$(\"a[title='Xem giao dịch']\")[0].click();");
                    },
                    child: const Text("lấy gd")),
                ElevatedButton(
                    onPressed: () async {
                      var htmlStr = await iawControlller?.evaluateJavascript(
                          source:
                              "window.document.getElementsByTagName('html')[0].outerHTML;");
                      //print("trieuvd content html: $htmlStr");
                      var document = parse(htmlStr);
                      //print("content html: ${document.getElementsByClassName('colour1')[0].getElementsByTagName('td')[1].innerHtml}");
                      _setTextTransaction(document
                          .getElementsByClassName('colour1')[0]
                          .getElementsByTagName('td')[1]
                          .innerHtml);
                    },
                    child: const Text("show gd")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
