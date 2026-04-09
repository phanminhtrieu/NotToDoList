# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["NotToDoList.csproj", "./"]
RUN dotnet restore "./NotToDoList.csproj"

COPY . .
RUN dotnet build "./NotToDoList.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./NotToDoList.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Listen tất cả IP
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "NotToDoList.dll"]
