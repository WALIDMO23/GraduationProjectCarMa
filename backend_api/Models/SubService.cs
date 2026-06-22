using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace CarMaintenance.Models
{
    public class SubService
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(200)]
        public string Name { get; set; } = string.Empty;

        [Required]
        public int ServiceId { get; set; }

        [ForeignKey("ServiceId")]
        [JsonIgnore]
        public virtual Service? Service { get; set; }
    }
}
