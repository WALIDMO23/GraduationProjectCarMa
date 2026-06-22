using System.ComponentModel.DataAnnotations;

namespace CarMaintenance.Models
{
    public class AdminActivityLog
    {
        [Key]
        public int Id { get; set; }

        public int AdminUserId { get; set; }
        public User AdminUser { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        public string Action { get; set; } = string.Empty;

        [Required]
        [MaxLength(1000)]
        public string Description { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? TargetType { get; set; }

        public int? TargetId { get; set; }

        [MaxLength(100)]
        public string? IpAddress { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
