# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy file sln và csproj vào đúng cấu trúc thư mục
COPY ["WebApplication1.sln", "./"]
COPY ["WebApplication1/WebApplication1.csproj", "WebApplication1/"]

# Restore các thư viện
RUN dotnet restore "WebApplication1/WebApplication1.csproj"

# Copy toàn bộ code còn lại
COPY . .

# Build dự án
WORKDIR "/src/WebApplication1"
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Run
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Railway tự động nhận diện PORT, nhưng ta nên chỉ định rõ
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "WebApplication1.dll"]