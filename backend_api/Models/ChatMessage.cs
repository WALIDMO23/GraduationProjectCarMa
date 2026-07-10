using System;
using System.ComponentModel.DataAnnotations;

namespace CarMaintenance.Models
{
    public class ChatMessage
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ServiceRequestId { get; set; }

        [Required]
        public int SenderId { get; set; }

        [Required]
        public string SenderName { get; set; } = string.Empty;

        [Required]
        public string MessageText { get; set; } = string.Empty;

        public DateTime Timestamp { get; set; } = DateTime.UtcNow;

        public bool IsRead { get; set; } = false;
    }
}
