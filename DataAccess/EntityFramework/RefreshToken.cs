using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DataAccess.Identity;

namespace DataAccess.EntityFramework;

public class RefreshToken
{
        [Key]
        public Guid RefreshTokenId { get; set; }

        [Required]
        [MaxLength(450)]
        public string UserId { get; set; }

        [Required]
        [MaxLength(100)]
        public string ClientId { get; set; }

        [Required]
        [MaxLength(256)]
        public string TokenHash { get; set; }

        public DateTime IssuedAt { get; set; }

        public DateTime ExpiresAt { get; set; }

        public DateTime? RevokedAt { get; set; }

        public Guid? ReplacedByTokenId { get; set; }

        [MaxLength(50)]
        public string? IpAddress { get; set; }

        [MaxLength(250)]
        public string? UserAgent { get; set; }

        [ForeignKey("UserId")]
        public virtual ApplicationUser User { get; set; }
}
