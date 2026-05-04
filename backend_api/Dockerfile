# مرحلة البناء - بنستخدم الـ SDK العادي
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# بننسخ ملف المشروع من مكانه المظبوط (لأننا جوه فولدر backend_api)
COPY ["CarMaintenance.csproj", "./"]
RUN dotnet restore "CarMaintenance.csproj"

# بننسخ باقي الكود وبنعمل Publish
COPY . .
RUN dotnet publish "CarMaintenance.csproj" -c Release -o /app/publish /p:UseAppHost=false

# المرحلة النهائية - الـ Runtime النضيف
FROM mcr.microsoft.com/dotnet/aspnet:9.0-bookworm-slim AS final
WORKDIR /app
COPY --from=build /app/publish .

# السطر الجوكر اللي هيمنع الـ Error 139 للأبد إن شاء الله
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "CarMaintenance.dll"]