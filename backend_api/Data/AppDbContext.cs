using Microsoft.EntityFrameworkCore;
using CarMaintenance.Models;

namespace CarMaintenance.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        // Tables
        public DbSet<TestItem> TestItems { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<Service> Services { get; set; }
        public DbSet<SubService> SubServices { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Car> Cars { get; set; }
        public DbSet<NewNotification> NewNotifications { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<UserSettings> UserSettings { get; set; }
        public DbSet<Workshop> Workshops { get; set; }
        public DbSet<AdminActivityLog> AdminActivityLogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // ================= ORDER CONFIG =================
            modelBuilder.Entity<Order>(entity =>
            {
                entity.HasKey(o => o.Id);

                entity.Property(o => o.Address)
                      .IsRequired()
                      .HasMaxLength(500);

                entity.Property(o => o.PhoneNumber)
                      .IsRequired()
                      .HasMaxLength(20);

                entity.Property(o => o.Price)
                      .HasColumnType("decimal(18,2)");

                entity.Property(o => o.OrderStatus)
                      .HasConversion<string>()
                      .HasMaxLength(20);

                // Relation: Order -> Notifications (1 to many)
                entity.HasMany(o => o.Notifications)
                      .WithOne(n => n.Order)
                      .HasForeignKey(n => n.OrderId)
                      .OnDelete(DeleteBehavior.Cascade);

                // Reporting Indexes
                entity.HasIndex(o => o.CreatedAt);
                entity.HasIndex(o => o.OrderStatus);
                entity.HasIndex(o => o.ServiceId);
                entity.HasIndex(o => new { o.OrderStatus, o.IsPaid, o.CreatedAt });
            });

            // ================= SERVICE SEED DATA (The 6 Services) =================
            modelBuilder.Entity<Service>().HasData(
                new Service { Id = 1, Name = "غيار زيت", Description = "تغيير زيت المحرك مع الفلتر", Price = 300 },
                new Service { Id = 2, Name = "بطارية", Description = "فحص وتغيير بطارية السيارة", Price = 500 },
                new Service { Id = 3, Name = "تغير إطار", Description = "إصلاح أو تبديل إطارات السيارة", Price = 250 },
                new Service { Id = 4, Name = "غسيل", Description = "غسيل وتنظيف السيارة بالكامل", Price = 150 },
                new Service { Id = 5, Name = "صيانة طارئة", Description = "إصلاح أعطال مفاجئة في الموقع", Price = 450 },
                new Service { Id = 6, Name = "ونش", Description = "خدمة سحب وإنقاذ السيارات", Price = 600 }
            );

            // ================= SUBSERVICE SEED DATA =================
            modelBuilder.Entity<SubService>().HasData(
                // 1: الزيت
                new SubService { Id = 4, Name = "تغيير زيت محرك", ServiceId = 1 },
                new SubService { Id = 5, Name = "تغيير زيت فتيس", ServiceId = 1 },
                new SubService { Id = 6, Name = "فحص مستوي الزيت", ServiceId = 1 },

                // 2: البطارية
                new SubService { Id = 1, Name = "شحن", ServiceId = 2 },
                new SubService { Id = 2, Name = "تغيير", ServiceId = 2 },
                new SubService { Id = 3, Name = "شراء", ServiceId = 2 },

                // 3: الاطارات
                new SubService { Id = 7, Name = "نفخ", ServiceId = 3 },
                new SubService { Id = 8, Name = "تغيير", ServiceId = 3 },
                new SubService { Id = 9, Name = "لحام", ServiceId = 3 },

                // 4: غسيل
                new SubService { Id = 10, Name = "خارجي وداخلي", ServiceId = 4 },
                new SubService { Id = 11, Name = "خارجي", ServiceId = 4 },
                new SubService { Id = 12, Name = "تنظيف جاف", ServiceId = 4 },

                // 5: صيانة طارئة
                new SubService { Id = 13, Name = "ميكانيكا وكهربا سريعه", ServiceId = 5 },
                new SubService { Id = 14, Name = "توصيل وقود بنزين", ServiceId = 5 },
                new SubService { Id = 15, Name = "فتح ابواب السياره", ServiceId = 5 },

                // 6: الونش
                new SubService { Id = 16, Name = "ونش انقاذ مسطح", ServiceId = 6 },
                new SubService { Id = 17, Name = "ونش سحب", ServiceId = 6 },
                new SubService { Id = 18, Name = "ونش هيدروليك", ServiceId = 6 }
            );

            // ================= USER CONFIG =================
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            // ================= NOTIFICATION CONFIG =================
            modelBuilder.Entity<Notification>(entity =>
            {
                entity.HasKey(n => n.Id);

                entity.Property(n => n.Title)
                      .IsRequired()
                      .HasMaxLength(200);

                entity.Property(n => n.Description)
                      .HasMaxLength(1000);

                entity.Property(n => n.Type)
                      .HasMaxLength(50);
            });

            // ================= NEW NOTIFICATION CONFIG =================
            modelBuilder.Entity<NewNotification>(entity =>
            {
                entity.HasKey(x => x.Id);

                entity.Property(x => x.Title)
                    .HasMaxLength(150)
                    .IsRequired();

                entity.Property(x => x.Message)
                    .HasMaxLength(1000)
                    .IsRequired();

                entity.Property(x => x.Type)
                    .HasConversion<int>()
                    .IsRequired();

                entity.Property(x => x.Severity)
                    .HasConversion<int>()
                    .IsRequired();

                entity.Property(x => x.ActionUrl)
                    .HasMaxLength(500);

                entity.Property(x => x.PrimaryActionLabel)
                    .HasMaxLength(100);

                entity.Property(x => x.PrimaryActionUrl)
                    .HasMaxLength(500);

                entity.Property(x => x.SecondaryActionLabel)
                    .HasMaxLength(100);

                entity.Property(x => x.SecondaryActionUrl)
                    .HasMaxLength(500);

                entity.Property(x => x.TargetType)
                    .HasMaxLength(100);

                entity.Property(x => x.MetadataJson)
                    .HasColumnType("jsonb");

                entity.Property(x => x.CreatedAt)
                    .IsRequired();

                entity.HasOne(x => x.User)
                    .WithMany()
                    .HasForeignKey(x => x.UserId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasIndex(x => new { x.UserId, x.IsDeleted, x.CreatedAt });
                entity.HasIndex(x => new { x.UserId, x.IsRead });
                entity.HasIndex(x => x.Type);
            });

            // ================= WORKSHOP CONFIG =================
            modelBuilder.Entity<Workshop>(entity =>
            {
                entity.HasKey(w => w.Id);

                entity.Property(w => w.Name)
                      .IsRequired()
                      .HasMaxLength(200);

                entity.Property(w => w.OwnerName)
                      .IsRequired()
                      .HasMaxLength(200);

                entity.Property(w => w.PhoneNumber)
                      .IsRequired()
                      .HasMaxLength(20);

                entity.Property(w => w.Email)
                      .IsRequired()
                      .HasMaxLength(200);

                entity.HasIndex(w => w.Email)
                      .IsUnique();

                entity.Property(w => w.Address)
                      .IsRequired()
                      .HasMaxLength(500);

                entity.HasIndex(w => w.IsActive);
                entity.HasIndex(w => w.IsOpen);
            });

            // ================= ADMIN ACTIVITY LOG CONFIG =================
            modelBuilder.Entity<AdminActivityLog>(entity =>
            {
                entity.HasKey(x => x.Id);

                entity.Property(x => x.Action)
                    .HasMaxLength(100)
                    .IsRequired();

                entity.Property(x => x.Description)
                    .HasMaxLength(1000)
                    .IsRequired();

                entity.Property(x => x.TargetType)
                    .HasMaxLength(100);

                entity.Property(x => x.IpAddress)
                    .HasMaxLength(100);

                entity.Property(x => x.CreatedAt)
                    .IsRequired();

                entity.HasOne(x => x.AdminUser)
                    .WithMany()
                    .HasForeignKey(x => x.AdminUserId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasIndex(x => new { x.AdminUserId, x.CreatedAt });
            });
        }
    }
}