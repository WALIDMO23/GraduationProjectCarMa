# استخدام بيئة دوت نت 8 للبناء (لو منجي شغال بنسخة 7 غير الرقم)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# نسخ ملف المشروع وتحميل المكاتب
COPY ["CarMaintenance.csproj", "./"]
RUN dotnet restore "CarMaintenance.csproj"

# نسخ باقي الملفات وعمل نسخة نهائية (Publish)
COPY . .
RUN dotnet publish "CarMaintenance.csproj" -c Release -o /app/publish

# استخدام بيئة خفيفة للتشغيل الفعلي على السيرفر
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# تظبيط البورت اللي Render بيحتاجه
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# تشغيل الـ API
ENTRYPOINT ["dotnet", "CarMaintenance.dll"]
