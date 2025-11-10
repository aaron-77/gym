using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Infraestructure.Auth;

public class RolesSeedConfiguration:IEntityTypeConfiguration<IdentityRole>
{


    public void Configure(EntityTypeBuilder<IdentityRole> builder)
    {
        builder.HasData(
             new IdentityRole { Id = "1", Name = Roles.Empleado, NormalizedName = Roles.Empleado.ToUpper() },
             new IdentityRole { Id = "2", Name = Roles.Cliente, NormalizedName = Roles.Cliente.ToUpper() }
         );

        
    }
}