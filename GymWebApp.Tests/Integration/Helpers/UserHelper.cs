using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

public static class UserHelper
{
    public static async Task<string> GetUserIdByRoleAsync(string connectionString, string roleName)
    {
        var userFromDb = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id 
              FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = @RoleName",
            new() { ["@RoleName"] = roleName }
        );
        return userFromDb?["Id"]?.ToString() ?? throw new InvalidOperationException($"No user found with role {roleName}");
    }
    
    public static async Task<string> GetAnyUserIdAsync(string connectionString)
    {
        var userFromDb = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 Id FROM AspNetUsers"
        );
        return userFromDb?["Id"]?.ToString() ?? throw new InvalidOperationException("No users found");
    }
}