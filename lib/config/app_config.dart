class Env {
  static const String n8nBaseUrl = 'https://n8n.flowmaticai.cloud/webhook';
  static const String testn8nBaseUrl = 'https://n8n.flowmaticai.cloud/webhook-test';
  static const String chatwootWebhookUrl       = '$n8nBaseUrl/chatwoot';
  static const String registrationWebhookUrl   = '$testn8nBaseUrl/register-user';
  static const String getconvWebhookUrl        = '$n8nBaseUrl/get-conversations';
  static const String updateWebhookUrl         = '$n8nBaseUrl/update-user';
  static const String deleteWebhookUrl         = '$n8nBaseUrl/delete-user';
  static const String getmessageWebhookUrl     = '$n8nBaseUrl/get-messages';
  static const String sendmessageWebhookUrl    = '$n8nBaseUrl/send-message';
  static const String chatIdentityWebhookUrl   = '$n8nBaseUrl/chat-identity';


  // ✅ Chatwoot WebWidget config
  static const String chatwootBaseUrl = 'https://cw.flowmaticai.cloud';
  static const String chatwootWebsiteToken = '5NbJFuJ6YGP9Mpnj1smzPg9N';
  // ✅ Supabase Auth config
  static const String supabaseUrl = 'https://vzvylaawmgumtlgysllx.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6dnlsYWF3bWd1bXRsZ3lzbGx4Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NjgwNDU4MCwiZXhwIjoyMDYyMzgwNTgwfQ.TTuFyJSGXLjtD-IwcPkd-kzAX5XQIQ5QpLGbT08VZaU'; 

}