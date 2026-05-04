# هنستخدم الـ SDK العادي لأنه دايمًا متاح وموجود
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# خطوات الـ Restore والـ Publish المعتادة
COPY ["backend_api/CarMaintenance.csproj", "backend_api/"]
RUN dotnet restore "backend_api/CarMaintenance.csproj"
COPY . .
WORKDIR "/src/backend_api"
RUN dotnet publish "CarMaintenance.csproj" -c Release -o /app/publish /p:UseAppHost=false

# هنا بقى السر: هنستخدم Ubuntu Jammy للـ Runtime بس
# ولو الـ 9.0-jammy لسه منزلتش، الـ 8.0-jammy دايمًا موجودة وشغالة
FROM mcr.microsoft.com/dotnet/aspnet:9.0-bookworm-slim AS final
WORKDIR /app
COPY --from=build /app/publish .

# السطر ده هو "الجوكر" اللي بيحل خناقة الـ Memory في لينكس
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "CarMaintenance.dll"]