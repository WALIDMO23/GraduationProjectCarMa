using System.Text;
using System.Text.Json;

namespace CarMaintenance.Services
{
    public class GeminiAiService
    {
private readonly string _apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY");
        
        private readonly string _apiUrl =
    "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";        public async Task<string> GetSmartAssistantResponse(string userMessage)
        {
            using var client = new HttpClient();

            var requestUrl = $"{_apiUrl}?key={_apiKey}";

            string systemPrompt = @"
أنت مساعد ذكي في تطبيق خدمات سيارات.

ارجع الرد بصيغة JSON فقط:
{
  ""message"": ""..."",
  ""action"": ""WINCH | WASH | MAINTENANCE | NONE""
}

القواعد:
- عطل أو حادث → WINCH
- غسيل → WASH
- صيانة أو زيت → MAINTENANCE
- غير كده → NONE
";

            var fullPrompt = systemPrompt + "\nUser: " + userMessage;

            var payload = new
            {
                contents = new[]
                {
                    new
                    {
                        parts = new[]
                        {
                            new { text = fullPrompt }
                        }
                    }
                }
            };

            var json = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            try
            {
                var response = await client.PostAsync(requestUrl, content);
                var responseString = await response.Content.ReadAsStringAsync();

                // 🔥 مهم: إظهار الخطأ الحقيقي لو حصل
                if (!response.IsSuccessStatusCode)
                {
                    return $"API ERROR {response.StatusCode}: {responseString}";
                }

                using JsonDocument doc = JsonDocument.Parse(responseString);

                var text = doc.RootElement
                    .GetProperty("candidates")[0]
                    .GetProperty("content")
                    .GetProperty("parts")[0]
                    .GetProperty("text")
                    .GetString();

                return text;
            }
            catch (Exception ex)
            {
                return $"ERROR: {ex.Message}";
            }
        }
    }
}