using System;
using System.Collections.Generic;

namespace DataAccess.EntityFramework;

public partial class AccessToken
{
    public Guid AccessTokenId { get; set; }

    public string UserId { get; set; } = null!;

    public string ClientId { get; set; } = null!;

    public string TokenHash { get; set; } = null!;

    public DateTime IssuedAt { get; set; }

    public DateTime ExpiresAt { get; set; }

    public DateTime? RevokedAt { get; set; }

    public string? IpAddress { get; set; }

    public string? UserAgent { get; set; }

    public virtual AspNetUser User { get; set; } = null!;
}
