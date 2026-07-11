using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;

namespace CarMaintenance.Services
{
    public class GeminiAiService
    {
        private readonly string? _apiKey;

        // Use v1beta with gemini-2.5-flash – working endpoint
        private readonly string _apiUrl =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";        public async Task<string> GetSmartAssistantResponse(string userMessage)
        {
            Console.WriteLine($"[CarMa AI] GetSmartAssistantResponse called with userMessage: '{userMessage}'");

            if (string.IsNullOrEmpty(_apiKey) || _apiKey == "YOUR_NEW_GEMINI_API_KEY_HERE")
            {
                Console.WriteLine("WARNING: GEMINI_API_KEY is not set. Using fallback response.");
                return GetFallbackResponseJson(userMessage);
            }

            using var client = new HttpClient();
            client.Timeout = TimeSpan.FromSeconds(30);

            var requestUrl = $"{_apiUrl}?key={_apiKey}";
            Console.WriteLine($"[CarMa AI] Sending request to Google Gemini API (endpoint: {_apiUrl})");

            // ── Full CarMa AI System Prompt for structured JSON responses ─────────────────
            string systemPrompt = @"
أنت CarMa AI، المساعد الذكي الرسمي لتطبيق CarMa لخدمات السيارات.
مهمتك الأساسية هي مساعدة المستخدم والتحكم في التطبيق من خلال إرجاع كائن JSON دقيق يحتوي على الحقول التالية:
- message: نص الرد للمستخدم باللهجة المصرية وبشكل ودود ومختصر يوضح ما سيحدث.
- action: الإجراء المطلوب تنفيذه. يجب اختيار أحد الإجراءات التالية بدقة بناءً على نية المستخدم:
  * open_location_picker (إذا نسى مكان ركن السيارة أو أراد تحديد موقعه)
  * open_payment (للذهاب لصفحة الدفع)
  * open_profile (للذهاب للملف الشخصي)
  * open_order_history (لسجل الطلبات)
  * open_chat (للمحادثة مع الفني)
  * open_active_order (لتتبع الطلب النشط أو لمعرفة مكان الفني)
  * open_technician (لمشاهدة معلومات الفني)
  * open_towing_service (عند طلب ونش أو سيارة لا تتحرك)
  * open_battery_service (عند مشكلة في البطارية أو السيارة لا تدور)
  * open_tire_service (عند ثقب أو تلف الإطار)
  * open_oil_service (لتغيير الزيت)
  * open_carwash_service (لطلب غسيل السيارة)
  * open_emergency_service (لحالات الحوادث أو الطوارئ الشديدة)
  * open_fuel_delivery (عند نفاد البنزين أو الوقود)
  * create_service_request (لإنشاء طلب خدمة)
  * none (إذا كان مجرد استفسار عام أو تحية أو في حال الحاجة لسؤال توضيحي بدلاً من التخمين)
- parameters: كائن يحتوي على أي بارامترات إضافية اختيارية، مثل {'serviceId': 3} أو {}.

قواعد مهمة جداً:
1. يجب أن يكون الرد دائماً بصيغة JSON صالحة فقط. لا تكتب أي كلام خارج كائن الـ JSON.
2. إذا كانت مشكلة المستخدم غير واضحة أو تحتمل أكثر من خدمة، لا تخمن الخدمة بل اسأل سؤالاً توضيحياً واحداً واجعل الـ action هو none.
3. التزم بأسماء الـ actions المذكورة أعلاه حرفياً.
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
                },
                generationConfig = new
                {
                    responseMimeType = "application/json"
                }
            };

            var json = JsonSerializer.Serialize(payload);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            try
            {
                var response = await client.PostAsync(requestUrl, content);
                var responseString = await response.Content.ReadAsStringAsync();

                Console.WriteLine($"[CarMa AI] Google API returned HTTP {(int)response.StatusCode} {response.StatusCode}");

                if (!response.IsSuccessStatusCode)
                {
                    var errMessage = $"HTTP {response.StatusCode}: {responseString}";
                    Console.WriteLine($"[CarMa AI] {errMessage}");
                    return errMessage;
                }

                using JsonDocument doc = JsonDocument.Parse(responseString);

                var text = doc.RootElement
                    .GetProperty("candidates")[0]
                    .GetProperty("content")
                    .GetProperty("parts")[0]
                    .GetProperty("text")
                    .GetString();

                if (string.IsNullOrEmpty(text))
                {
                    return GetFallbackResponseJson(userMessage);
                }

                // Strip potential markdown code blocks if any
                text = text.Trim();
                if (text.StartsWith("```json"))
                {
                    text = text.Substring(7);
                }
                if (text.StartsWith("```"))
                {
                    text = text.Substring(3);
                }
                if (text.EndsWith("```"))
                {
                    text = text.Substring(0, text.Length - 3);
                }
                text = text.Trim();

                Console.WriteLine($"[CarMa AI] Parsed Gemini reply: {text}");

                // Validate it parses as JSON object
                using var testParse = JsonDocument.Parse(text);
                return text;
            }
            catch (Exception ex)
            {
                var errMessage = $"Exception: {ex.Message}";
                Console.WriteLine($"[CarMa AI] {errMessage}");
            }
        }

        private string GetFallbackResponseJson(string message)
        {
            message = message.ToLower().Trim();
            string replyText;
            string action = "none";

            // Towing / Emergency
            if (message.Contains("ونش") || message.Contains("حادث") || message.Contains("مش بتتحرك") || message.Contains("لا تتحرك"))
            {
                replyText = "يبدو إن الحالة تحتاج ونش إنقاذ فورًا. هفتحلك صفحة خدمة الونش.";
                action = "open_towing_service";
            }
            // Tire
            else if (message.Contains("إطار") || message.Contains("بنشر") || message.Contains("عجل"))
            {
                replyText = "مشكلة الإطار ممكن نحلها بسرعة. هفتحلك صفحة خدمة الإطارات.";
                action = "open_tire_service";
            }
            // Battery
            else if (message.Contains("بطارية") || message.Contains("مش بتشتغل") || message.Contains("مش شغالة"))
            {
                replyText = "البطارية ممكن تكون المشكلة. هفتحلك صفحة خدمة البطاريات.";
                action = "open_battery_service";
            }
            // Oil
            else if (message.Contains("زيت"))
            {
                replyText = "يفضل تغيير الزيت كل 5000 كم. هفتحلك صفحة خدمة الزيت.";
                action = "open_oil_service";
            }
            // Fuel
            else if (message.Contains("بنزين") || message.Contains("وقود") || message.Contains("خلص"))
            {
                replyText = "مش مشكلة! هنوصلك بنزين على طول. هفتحلك صفحة توصيل الوقود.";
                action = "open_fuel_delivery";
            }
            // Car Wash
            else if (message.Contains("غسيل") || message.Contains("نظافة") || message.Contains("غسل"))
            {
                replyText = "هنوصلك فريق غسيل متنقل في أي مكان. هفتحلك صفحة غسيل السيارات.";
                action = "open_carwash_service";
            }
            // General car problem
            else if (message.Contains("عطل") || message.Contains("عربية") || message.Contains("سيارة"))
            {
                replyText = "ممكن توضحلي أكتر إيه المشكلة اللي بتواجهك بالظبط عشان أقدر أساعدك؟";
                action = "none";
            }
            // Greeting
            else if (message.Contains("مرحبا") || message.Contains("أهلاً") || message.Contains("hello") || message.Contains("hi"))
            {
                replyText = "أهلاً! أنا CarMa AI، مساعدك الذكي. قولي إيه المشكلة وأنا هساعدك فوراً.";
                action = "none";
            }
            else
            {
                replyText = "أهلاً! أنا CarMa AI. قولي إيه المشكلة اللي بتواجهك بالظبط عشان أقدر أساعدك.";
                action = "none";
            }

            var fallbackObj = new
            {
                message = replyText,
                action = action,
                parameters = new Dictionary<string, object>()
            };

            return JsonSerializer.Serialize(fallbackObj);
        }
    }
}