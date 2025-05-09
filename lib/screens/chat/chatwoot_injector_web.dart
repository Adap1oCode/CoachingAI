import 'dart:html' as html;
import 'dart:js' as js;

void injectChatwoot({
  required String baseUrl,
  required String websiteToken,
  String? identifier,
  String? hmac,
}) {
  // Create and inject the script element
  final script = html.ScriptElement()
    ..type = 'text/javascript'
    ..defer = true
    ..async = true
    ..src = '$baseUrl/packs/js/sdk.js';

  // Log to confirm that we're injecting the script
  print("Injecting Chatwoot SDK...");

  // Append the script to the body immediately
  html.document.body?.append(script);
  print("Chatwoot SDK script appended to the body.");

  // Handle script load event
  script.onLoad.listen((_) {
    print("Chatwoot SDK loaded successfully.");

    // Check if chatwootSDK is available in window
    final chatwootSDK = js.context['chatwootSDK'];

    if (chatwootSDK != null) {
      print("chatwootSDK is available, calling 'run' method.");

      final config = {
        'websiteToken': websiteToken,
        'baseUrl': baseUrl,
        'type': 'sdk',
        if (identifier != null && hmac != null)
          'contact': {
            'identifier': identifier,
            'hmac': hmac,
          }
      };

      // Correct JavaScript interop call using the chatwootSDK object
      chatwootSDK.callMethod('run', [config]);
      print("Chatwoot SDK run method called.");
    } else {
      print("Error: chatwootSDK is not available on window.");
    }
  });

  // Handle script load failure
  script.onError.listen((e) {
    print("Error loading Chatwoot SDK: $e");
  });
}
