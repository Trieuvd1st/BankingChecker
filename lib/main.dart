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
  GestureDetector? gestureDetector;

  void _setTextTransaction(String text) {
    setState(() {
      textTransaction = text;
    });
  }

  @override
  void initState() {
    super.initState();

    gestureDetector = GestureDetector(
      onTap: () {
        print("TRIEUVD: onTap webview");
      },
      child: Container(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse(
                  "https://ib.techcombank.com.vn/servlet/BrowserServlet")),
          onWebViewCreated: (InAppWebViewController controller) {
            iawControlller = controller;
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            print("get step $getTransactionStep");
            if (getTransactionStep == 0) {
              await iawControlller?.evaluateJavascript(
                  source:
                      "javascript:document.getElementsByName('AI.QCK.ACCOUNT')[0].click()");
              getTransactionStep++;
            }
          },
        ),
      ),
    );
  }

  // void onTapDown(BuildContext context, TapDownDetails details) {
  //   print('${details.globalPosition}');
  //   final RenderBox box = context.findRenderObject();
  //   final Offset localOffset = box.globalToLocal(details.globalPosition);
  //   setState(() {
  //     posx = localOffset.dx;
  //     posy = localOffset.dy;
  //   });
  // }

  Widget _dalkjfsdf(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              Opacity(opacity: 1, child: gestureDetector ?? const SizedBox()),
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
        TextField(controller: passController),
        const SizedBox(height: 40),
        Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  iawControlller?.evaluateJavascript(
                      source:
                          "javascript:\$('#signOnName').val('01627093838');");
                  iawControlller?.evaluateJavascript(
                      source: "javascript:\$('#password').val('Hoilg12!');");
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
                  gestureDetector?.onTap;
                },
                child: const Text("chuyển tab tk")),
            ElevatedButton(
                onPressed: () async {
                  iawControlller?.evaluateJavascript(
                      source:
                          "javascript:\$(\"a[title='Xem giao dịch']\")[0].click();");
                  // iawControlller?.evaluateJavascript(
                  //     source:
                  //         "javascript:\$(\"input[name='fieldName:START.DATE']\").focus();");
                  // iawControlller?.evaluateJavascript(source: "javascript:\$(\"input[name='fieldName:START.DATE']\").val('01/09/2021');");
                  // iawControlller?.evaluateJavascript(source: "javascript:\$(\"input[name='fieldName:END.DATE']\").val('01/11/2021');");
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          child: _dalkjfsdf(context),
        ),
      ),
    );
  }
}
