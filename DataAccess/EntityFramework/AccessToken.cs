using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DataAccess.Identity;

namespace DataAccess.EntityFramework;

public partial class AccessToken
{
     [Key]
        public Guid AccessTokenId { get; set; }

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

        [MaxLength(50)]
        public string? IpAddress { get; set; }

        [MaxLength(250)]
        public string? UserAgent { get; set; }

        [ForeignKey("UserId")]
        public virtual ApplicationUser User { get; set; }
}
