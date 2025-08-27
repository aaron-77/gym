using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Infraestructure.Auth
{
        public class UsuarioSeedConfiguration : IEntityTypeConfiguration<ApplicationUser>
        {
                public void Configure(EntityTypeBuilder<ApplicationUser> builder)
                {
                    
                }
        }
}