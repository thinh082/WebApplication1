# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

# Copy csproj và restore trước để tận dụng Docker cache
COPY ["WebApplication1.csproj", "./"]
RUN dotnet restore "WebApplication1.csproj"

# Copy toàn bộ code và build
COPY . .
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Run
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine
WORKDIR /app
COPY --from=build /app/publish .

# Render yêu cầu chạy app qua biến môi trường PORT
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "WebApplication1.dll"]