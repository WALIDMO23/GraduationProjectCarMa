# مرحلة الـ build هتبقى ubuntu
FROM mcr.microsoft.com/dotnet/sdk:9.0-jammy AS build
WORKDIR /src
# ... باقي الخطوات المعتادة ...

# مرحلة الـ final هتبقى ubuntu jammy الكاملة
FROM mcr.microsoft.com/dotnet/aspnet:9.0-jammy AS final
WORKDIR /app
COPY --from=build /app/publish .

# السطر ده إجباري المرة دي
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "CarMaintenance.dll"]