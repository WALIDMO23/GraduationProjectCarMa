using CarMaintenance.Services.Interfaces;
using CarMaintenance.Services.Implementation;
using CarMaintenance.Services; // 👈 مهم جدًا (عشان GeminiAiService)
using Microsoft.EntityFrameworkCore;
using CarMaintenance.Data;

var builder = WebApplication.CreateBuilder(args);

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Services
builder.Services.AddScoped<IOrderService, OrderService>();

// 🔥 AI SERVICE (ده اللي كان ناقصك)
builder.Services.AddScoped<GeminiAiService>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "Car Maintenance API",
        Version = "v1",
        Description = "API for the Car Maintenance management system — includes admin dashboard, notifications, order search, and test items."
    });
    options.EnableAnnotations();
});

// DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseInMemoryDatabase("CarMaintenanceDb"));

var app = builder.Build();

// Ensure Database is created and add mockup data
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    context.Database.EnsureCreated();

    if (!context.Orders.Any())
    {
        context.Orders.AddRange(
            new CarMaintenance.Models.Order
            {
                UserId = 1,
                VehicleId = 1,
                ServiceId = 1,
                Address = "123 Main St",
                PhoneNumber = "555-1234",
                OrderStatus = CarMaintenance.Models.OrderStatus.New,
                CreatedAt = DateTime.UtcNow.AddDays(-1)
            },
            new CarMaintenance.Models.Order
            {
                UserId = 2,
                VehicleId = 2,
                ServiceId = 2,
                Address = "456 Oak St",
                PhoneNumber = "555-5678",
                OrderStatus = CarMaintenance.Models.OrderStatus.Completed,
                CreatedAt = DateTime.UtcNow.AddDays(-2)
            }
        );

        context.SaveChanges();
    }
}

// Middleware order
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

app.Run();