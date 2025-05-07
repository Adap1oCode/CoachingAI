import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';


class ChatwootWidgetScreen extends StatefulWidget {
  const ChatwootWidgetScreen({super.key});

  @override
  State<ChatwootWidgetScreen> createState() => _ChatwootWidgetScreenState();
}

class _ChatwootWidgetScreenState extends State<ChatwootWidgetScreen> {
  late final WebViewController _controller;

  final String chatwootHTML = '''
  <!DOCTYPE html>
  <html>
  <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
  <body>
    <h2>Chat Assistant</h2>
    <p>The Chatwoot widget should appear in the bottom right corner.</p>
    <script>
      (function(d,t) {
        var BASE_URL="http://0.0.0.0:3000";
        var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
        g.src=BASE_URL+"/packs/js/sdk.js";
        g.defer = true;
        g.async = true;
        s.parentNode.insertBefore(g,s);
        g.onload=function(){
          window.chatwootSDK.run({
            websiteToken: '5NbJFuJ6YGP9Mpnj1smzPg9N',
            baseUrl: BASE_URL
          });
        }
      })(document,"script");
    </script>
  </body>
  </html>
  ''';

  @override
  void initState() {
    super.initState();

    // ✅ Initialize for Android
    WebView.platform = SurfaceAndroidWebView();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(chatwootHTML);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Assistant')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
