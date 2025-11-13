namespace DTO.Dtos
{
    /// <summary>
    /// Clase de configuración para los claims de los tokens JWT
    /// </summary>
    public class ClaimsSettings
    {
        /// <summary>
        /// Claims para el Access Token (Backend)
        /// </summary>
        public Dictionary<string, string> BackendTokenClaims { get; set; } = new();

        /// <summary>
        /// Claims para el ID Token (Frontend)
        /// </summary>
        public Dictionary<string, string> FrontendTokenClaims { get; set; } = new();

        /// <summary>
        /// Claims para el Refresh Token
        /// </summary>
        public Dictionary<string, string> RefreshTokenClaims { get; set; } = new();
    }
}
