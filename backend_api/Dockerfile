FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["CarMaintenance.csproj", "./"]
RUN dotnet restore "CarMaintenance.csproj"

COPY . .
RUN dotnet publish "CarMaintenance.csproj" -c Release -o /app/publish


FROM mcr.microsoft.com/dotnet/aspnet:9.0-jammy AS final
WORKDIR /app
COPY --from=build /app/publish .

# تريكة لتعطيل الـ Globalization لو هي السبب في الكراش
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "CarMaintenance.dll"]
