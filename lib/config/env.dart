class Env {
  static const String n8nBaseUrl = 'https://n8n.flowmaticai.cloud'; // Replace with actual
  static const String chatwootWebhookUrl = '$n8nBaseUrl/webhook/chatwoot';
  static const String registrationWebhookUrl = '$n8nBaseUrl/webhook/register-user';
  static const String chatHistoryWebhookUrl = '$n8nBaseUrl/webhook/chat-history';
  // Add the following lines for update and delete webhooks
  static const String updateWebhookUrl = '$n8nBaseUrl/webhook/update-user'; // Assuming a path for update
  static const String deleteWebhookUrl = '$n8nBaseUrl/webhook/delete-user'; // Assuming a path for delete
}

