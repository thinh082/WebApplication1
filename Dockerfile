# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy đúng file .slnx (có chữ x) và .csproj
COPY ["WebApplication1.slnx", "./"]
COPY ["WebApplication1/WebApplication1.csproj", "WebApplication1/"]

# Restore thư viện
RUN dotnet restore "WebApplication1/WebApplication1.csproj"

# Copy toàn bộ code còn lại
COPY . .

# Chuyển vào thư mục chứa code để build
WORKDIR "/src/WebApplication1"
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Run
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Cấu hình Port
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "WebApplication1.dll"]