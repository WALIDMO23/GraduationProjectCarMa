using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CarMaintenance.Data;
using CarMaintenance.DTOs;
using CarMaintenance.Models;
using CarMaintenance.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace CarMaintenance.Services.Implementation
{
    public class AdminActivityLogService : IAdminActivityLogService
    {
        private readonly AppDbContext _db;
        private readonly ILogger<AdminActivityLogService> _logger;

        public AdminActivityLogService(AppDbContext db, ILogger<AdminActivityLogService> logger)
        {
            _db = db;
            _logger = logger;
        }

        public async Task LogAsync(
            int adminUserId,
            string action,
            string description,
            string? targetType = null,
            int? targetId = null,
            string? ipAddress = null,
            CancellationToken cancellationToken = default)
        {
            try
            {
                var log = new AdminActivityLog
                {
                    AdminUserId = adminUserId,
                    Action = action,
                    Description = description,
                    TargetType = targetType,
                    TargetId = targetId,
                    IpAddress = ipAddress,
                    CreatedAt = DateTime.UtcNow
                };

                _db.AdminActivityLogs.Add(log);
                await _db.SaveChangesAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to log admin activity. Action: {Action}, AdminUserId: {AdminUserId}", action, adminUserId);
            }
        }

        public async Task<PagedAdminActivityLogsResponseDto> GetLogsAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken = default)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 50);

            var query = _db.AdminActivityLogs
                .Include(x => x.AdminUser)
                .AsNoTracking();

            int totalCount = await query.CountAsync(cancellationToken);
            int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

            var items = await query
                .OrderByDescending(x => x.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(x => new AdminActivityLogDto
                {
                    Id = x.Id,
                    AdminUserId = x.AdminUserId,
                    AdminUserName = x.AdminUser != null ? x.AdminUser.Name : "Unknown Admin",
                    Action = x.Action,
                    Description = x.Description,
                    TargetType = x.TargetType,
                    TargetId = x.TargetId,
                    IpAddress = x.IpAddress,
                    CreatedAt = x.CreatedAt
                })
                .ToListAsync(cancellationToken);

            return new PagedAdminActivityLogsResponseDto
            {
                Items = items,
                Page = page,
                PageSize = pageSize,
                TotalCount = totalCount,
                TotalPages = totalPages
            };
        }
    }
}
