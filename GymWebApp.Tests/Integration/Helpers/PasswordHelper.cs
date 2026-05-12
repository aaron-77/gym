using DataAccess.Identity;
using Microsoft.AspNetCore.Identity;

namespace GymWebApp.Tests.Integration.Helpers;

public class PasswordHelper
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly SignInManager<ApplicationUser> _signInManager;

    public PasswordHelper(
        UserManager<ApplicationUser> userManager,
        SignInManager<ApplicationUser> signInManager)
    {
        _userManager = userManager;
        _signInManager = signInManager;
    }

    public async Task<bool> VerifyPasswordAsync(string email, string password)
    {
        var user = await _userManager.FindByNameAsync(email);
        if (user == null)
            return false;

        var verificationResult = _userManager.PasswordHasher
            .VerifyHashedPassword(user, user.PasswordHash, password);

        if (verificationResult == PasswordVerificationResult.Failed)
            return false;

        var signInResult = await _signInManager
            .CheckPasswordSignInAsync(user, password, lockoutOnFailure: false);

        return signInResult.Succeeded;
    }
}