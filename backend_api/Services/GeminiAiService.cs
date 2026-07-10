using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;

namespace CarMaintenance.Services
{
    public class GeminiAiService
    {
        private readonly string? _apiKey;

        // Use v1 with gemini-2.5-flash – working endpoint (matches reference project)
        private readonly string _apiUrl =
            "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";

        public GeminiAiService(IConfiguration configuration)
        {
            // Prefer environment variable, fall back to appsettings
            _apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY")
                      ?? configuration["GeminiAI:ApiKey"];
        }

        public async Task<string> GetSmartAssistantResponse(string userMessage)
        {
            if (string.IsNullOrEmpty(_apiKey) || _apiKey == "YOUR_NEW_GEMINI_API_KEY_HERE")
            {
                Console.WriteLine("WARNING: GEMINI_API_KEY is not set. Using fallback response.");
                return GetFallbackResponse(userMessage);
            }

            using var client = new HttpClient();
            client.Timeout = TimeSpan.FromSeconds(30);

            var requestUrl = $"{_apiUrl}?key={_apiKey}";

            // ── Full CarMa AI System Prompt ──────────────────────────────────────
            string systemPrompt = @"
أنت CarMa AI، المساعد الذكي الرسمي لتطبيق CarMa لخدمات السيارات.

مهمتك الأساسية ليست فقط الإجابة على الأسئلة، بل مساعدة المستخدمين على استخدام كل ميزة داخل تطبيق CarMa.

لديك معرفة كاملة بالتطبيق بما يشمل:
- تسجيل الدخول والحساب (Authentication)
- الملف الشخصي (Profile)
- السيارات المسجلة (Vehicles)
- طلبات الخدمة (Service Requests)
- خدمات الطوارئ (Emergency Services)
- خدمة البطارية (Battery Service)
- خدمة الإطارات / البنشر (Tire Service)
- تغيير الزيت (Oil Change)
- غسيل السيارة (Car Wash)
- ونش السحب (Towing)
- توصيل الوقود (Fuel Delivery)
- تعيين الفني (Technician Assignment)
- تتبع الطلب المباشر (Live Order Tracking)
- المدفوعات (Payments)
- المحفظة (Wallet)
- انستا باي (InstaPay)
- الإشعارات (Notifications)
- خرائط GPS والبحث (Maps, GPS, Search)
- سجل الطلبات (Order History)
- الإعدادات (Settings)
- الدعم الفني (Support)
- المحادثة مع الفني (Chat with Technician)

قواعد سلوكك:

1. دائماً افهم نية المستخدم أولاً.

2. إذا أبلغ المستخدم عن مشكلة في سيارته، حدد الخدمة المناسبة:
   - إطار واقف / بنشر → اطلب خدمة الإطارات [MAINTENANCE_BUTTON]
   - بطارية فارغة → اطلب خدمة البطارية [MAINTENANCE_BUTTON]
   - السيارة مش بتتحرك → اطلب ونش [WINCH_BUTTON]
   - محتاج وقود → اطلب توصيل وقود [MAINTENANCE_BUTTON]
   - محتاج زيت → اطلب تغيير زيت [MAINTENANCE_BUTTON]
   - محتاج غسيل → اطلب غسيل السيارة [WASH_BUTTON]
   - طوارئ / حادث → اطلب خدمة الطوارئ [WINCH_BUTTON]

3. لا تعطي إجابات عامة من الذكاء الاصطناعي. بدلاً من ذلك، وجّه المستخدم خطوة بخطوة داخل التطبيق.

4. عند طلب خدمة، أخبر المستخدم بالخطوات:
   مثال: 'هساعدك تطلب ونش. هنختار موقعك الحالي، بعدين هتأكد الطلب، وتختار طريقة الدفع، وهيوصلك أقرب فني.'

5. استخدم رسائل قصيرة باللهجة المصرية:
   مثل: 'تمام.'، 'خليني أساعدك.'، 'هنبدأ دلوقتي.'، 'ماتقلقش.'

6. كن إيجابياً ومحترفاً ومتعلقاً بالسيارات دائماً.

7. لا تعرض أخطاء API أو تقنية خام للمستخدم أبداً.
   بدلاً من ذلك، اشرح المشكلة بلطف واقترح المحاولة مجدداً.

8. إذا انتهت جلسة المستخدم، وجّهه لتسجيل الدخول.

9. إذا فشل الدفع، وجّهه لاختيار طريقة دفع أخرى.

10. دعم اللغة العربية والإنجليزية تلقائياً.

11. كن استباقياً: إذا طلب إطاراً، اقترح أيضاً الونش أو الطوارئ إذا بدا محتاجاً.

12. ابقَ دائماً في سياق تطبيق CarMa. لا تتحدث عن مواضيع غير متعلقة.

13. الكلمات المفتاحية للأزرار:
    [WINCH_BUTTON] = اطلب ونش / طوارئ
    [WASH_BUTTON] = اطلب غسيل
    [MAINTENANCE_BUTTON] = اطلب صيانة / فني / بطارية / زيت / إطار / وقود
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

                if (!response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"[CarMa AI] HTTP {response.StatusCode}: {responseString}");
                    return HandleGeminiError(response.StatusCode.ToString(), responseString, userMessage);
                }

                using JsonDocument doc = JsonDocument.Parse(responseString);

                var text = doc.RootElement
                    .GetProperty("candidates")[0]
                    .GetProperty("content")
                    .GetProperty("parts")[0]
                    .GetProperty("text")
                    .GetString();

                return text ?? GetFallbackResponse(userMessage);
            }
            catch (TaskCanceledException)
            {
                return "الاتصال استغرق وقتاً طويلاً. حاول مرة تانية.";
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CarMa AI] Exception: {ex.Message}");
                return GetFallbackResponse(userMessage);
            }
        }

        private string HandleGeminiError(string status, string response, string message)
        {
            if (response.Contains("429") || response.Contains("RESOURCE_EXHAUSTED"))
            {
                return GetFallbackResponse(message);
            }
            if (response.Contains("403") || response.Contains("PERMISSION_DENIED"))
            {
                return GetFallbackResponse(message);
            }
            return GetFallbackResponse(message);
        }

        private string GetFallbackResponse(string message)
        {
            message = message.ToLower().Trim();

            // Towing / Emergency
            if (message.Contains("ونش") || message.Contains("حادث") || message.Contains("مش بتتحرك") || message.Contains("لا تتحرك"))
                return "يبدو إن الحالة تحتاج ونش إنقاذ فورًا. اطلب الخدمة دلوقتي [WINCH_BUTTON]";

            // Tire
            if (message.Contains("إطار") || message.Contains("بنشر") || message.Contains("عجل"))
                return "مشكلة الإطار ممكن نحلها بسرعة. هبعتلك فني متخصص [MAINTENANCE_BUTTON]";

            // Battery
            if (message.Contains("بطارية") || message.Contains("مش بتشتغل") || message.Contains("مش شغالة"))
                return "البطارية ممكن تكون المشكلة. هبعتلك فني بطارية [MAINTENANCE_BUTTON]";

            // Oil
            if (message.Contains("زيت"))
                return "يفضل تغيير الزيت كل 5000 كم. ممكن تطلب فني دلوقتي [MAINTENANCE_BUTTON]";

            // Fuel
            if (message.Contains("بنزين") || message.Contains("وقود") || message.Contains("خلص"))
                return "مش مشكلة! هنوصلك بنزين على طول. اطلب توصيل وقود [MAINTENANCE_BUTTON]";

            // Car Wash
            if (message.Contains("غسيل") || message.Contains("نظافة") || message.Contains("غسل"))
                return "هنوصلك فريق غسيل متنقل في أي مكان [WASH_BUTTON]";

            // General car problem
            if (message.Contains("عطل") || message.Contains("عربية") || message.Contains("سيارة"))
                return "وصفلي المشكلة أكتر وأنا هساعدك [MAINTENANCE_BUTTON]";

            // Greeting
            if (message.Contains("مرحبا") || message.Contains("أهلاً") || message.Contains("hello") || message.Contains("hi"))
                return "أهلاً! أنا CarMa AI، مساعدك الذكي. قولي إيه المشكلة وأنا هساعدك فوراً.";

            return "أهلاً! أنا CarMa AI. وصفلي مشكلتك مع العربية وهساعدك دلوقتي.";
        }
    }
}