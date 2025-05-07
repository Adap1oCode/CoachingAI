class Env {
  static const String n8nBaseUrl = 'https://n8n.flowmaticai.cloud/webhook-test'; // Replace with actual
  static const String chatwootWebhookUrl = '$n8nBaseUrl/chatwoot';
  static const String registrationWebhookUrl = '$n8nBaseUrl/register-user';
  static const String chatHistoryWebhookUrl = '$n8nBaseUrl/chat-history';
  // Add the following lines for update and delete webhooks
  static const String updateWebhookUrl = '$n8nBaseUrl/update-user'; // Assuming a path for update
  static const String deleteWebhookUrl = '$n8nBaseUrl/delete-user'; // Assuming a path for delete
}

