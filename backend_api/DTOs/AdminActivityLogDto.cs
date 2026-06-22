using System;
using System.Collections.Generic;

namespace CarMaintenance.DTOs
{
    public class AdminActivityLogDto
    {
        public int Id { get; set; }
        public int AdminUserId { get; set; }
        public string AdminUserName { get; set; } = string.Empty;
        public string Action { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string? TargetType { get; set; }
        public int? TargetId { get; set; }
        public string? IpAddress { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class PagedAdminActivityLogsResponseDto
    {
        public List<AdminActivityLogDto> Items { get; set; } = new();
        public int Page { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }
        public int TotalPages { get; set; }
    }
}
