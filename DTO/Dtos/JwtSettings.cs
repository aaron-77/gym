namespace DTO.Dtos{
    public class JwtSettings
    {
        public string SecretKey { get; set; }
        public string Issuer { get; set; }
        public string FrontAudiencie { get; set; }
        public string BackendAudiencie { get; set; }
        public string FrontendAudienceSsl { get; set; }
        public string BackendAudienceSsl { get; set; }
        public int ExpiryMinutes { get; set; }
        public int RefreshTokenExpiryDays { get; set; }
    }
}