namespace DTO.Dtos
{
    /// <summary>
    /// Enum que define los tipos de tokens JWT soportados
    /// </summary>
    public enum TokenType
    {
        /// <summary>
        /// Token para el frontend (ID Token)
        /// </summary>
        FrontendToken,

        /// <summary>
        /// Token para el backend (Access Token)
        /// </summary>
        BackendToken,

        /// <summary>
        /// Token de refresco
        /// </summary>
        RefreshToken
    }
}
