using CarMaintenance.Services.Interfaces;
using CarMaintenance.Services.Implementation;
using CarMaintenance.Services;
using Microsoft.EntityFrameworkCore;
using CarMaintenance.Data;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using CarMaintenance.Hubs;
using System.Text;
using CarMaintenance.Models;
using Microsoft.AspNetCore.SignalR;

var builder = WebApplication.CreateBuilder(args);

// ======================
// CORS
// ======================
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.SetIsOriginAllowed(_ => true)
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

// ======================
// Services
// ======================
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<INewNotificationService, NewNotificationService>();
builder.Services.AddScoped<IReportsService, ReportsService>();
builder.Services.AddScoped<IAdminActivityLogService, AdminActivityLogService>();
builder.Services.AddScoped<GeminiAiService>();
builder.Services.AddSingleton<IUserIdProvider, CustomUserIdProvider>();
builder.Services.AddMemoryCache();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// ======================
// Swagger + JWT + Annotations
// ======================
builder.Services.AddSwaggerGen(options =>
{
    options.EnableAnnotations();

    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Car Maintenance API",
        Version = "v1"
    });

    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

// ======================
// DB Context
// ======================
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// ======================
// JWT
// ======================
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,

        ValidIssuer = "CarServiceAPI",
        ValidAudience = "CarServiceAPI",

        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes("THIS_IS_MY_SUPER_SECRET_KEY_1234567890")
        )
    };

    options.Events = new JwtBearerEvents
    {
        OnMessageReceived = context =>
        {
            var accessToken = context.Request.Query["access_token"];
            var path = context.HttpContext.Request.Path;

            if (!string.IsNullOrEmpty(accessToken) &&
                path.StartsWithSegments("/hubs/notifications"))
            {
                context.Token = accessToken;
            }

            return Task.CompletedTask;
        }
    };
});

builder.Services.AddAuthorization();
builder.Services.AddSignalR();

var app = builder.Build();

// ======================
// SEED ADMIN 
// ======================
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    // ======================
    // self-healing migrations alignment
    // ======================
    try
    {
        context.Database.ExecuteSqlRaw(@"
            CREATE TABLE IF NOT EXISTS ""__EFMigrationsHistory"" (
                ""MigrationId"" character varying(150) NOT NULL,
                ""ProductVersion"" character varying(32) NOT NULL,
                CONSTRAINT ""PK___EFMigrationsHistory"" PRIMARY KEY (""MigrationId"")
            );

            INSERT INTO ""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"")
            VALUES ('20260511144619_AddCarsTable', '8.0.0')
            ON CONFLICT (""MigrationId"") DO NOTHING;

            INSERT INTO ""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"")
            VALUES ('20260519163927_StoreProfileImageInDatabase', '8.0.0')
            ON CONFLICT (""MigrationId"") DO NOTHING;

            ALTER TABLE ""Users"" DROP COLUMN IF EXISTS ""ProfileImageUrl"";
            ALTER TABLE ""Users"" ADD COLUMN IF NOT EXISTS ""ProfileImageData"" bytea;
            ALTER TABLE ""Users"" ADD COLUMN IF NOT EXISTS ""ProfileImageContentType"" text;

            CREATE TABLE IF NOT EXISTS ""ChatMessages"" (
                ""Id"" serial PRIMARY KEY,
                ""ServiceRequestId"" integer NOT NULL,
                ""SenderId"" integer NOT NULL,
                ""SenderName"" text NOT NULL,
                ""MessageText"" text NOT NULL,
                ""Timestamp"" timestamp with time zone NOT NULL DEFAULT NOW(),
                ""IsRead"" boolean NOT NULL DEFAULT FALSE
            );
        ");
        Console.WriteLine("Database schema and migrations aligned successfully.");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error aligning database schema: {ex.Message}");
    }

    if (!context.Users.Any(u => u.Role == "admin"))
    {
        context.Users.Add(new User
        {
            Name = "Abdlerahman",
            Email = "Elmongy@gmail.com",
            PasswordHash = "1122",
            PhoneNumber = "01000000000",
            Role = "admin"
        });

        context.SaveChanges();
    }
}

// ======================
// PIPELINE
// ======================
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowAll");

app.UseAuthentication();
app.UseStaticFiles();
app.UseAuthorization();

app.MapControllers();
app.MapHub<NotificationHub>("/hubs/notifications");

app.Run();