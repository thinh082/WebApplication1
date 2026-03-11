var builder = WebApplication.CreateBuilder(args);

// Đọc Port từ môi trường (Railway/Render cấp phát)
var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
builder.WebHost.UseUrls($"http://0.0.0.0:{port}");

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// SỬA ĐOẠN NÀY: Cho phép dùng Swagger ở cả môi trường Production
// Bỏ điều kiện app.Environment.IsDevelopment()
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
    c.RoutePrefix = string.Empty; // Để vào link gốc là thấy Swagger luôn, không cần gõ /swagger
});

// LƯU Ý: Trên Railway/Render thường dùng HTTP cho container, 
// nếu lỗi kết nối bạn có thể tạm comment dòng HttpsRedirection bên dưới
// app.UseHttpsRedirection(); 

app.UseAuthorization();
app.MapControllers();

app.Run();