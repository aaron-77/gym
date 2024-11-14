using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace DTO.CustomValidations
{
    public class ValidarPasswordAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            // Obtén el objeto completo que está siendo validado
            var modelo = (User)validationContext.ObjectInstance;

            if (string.IsNullOrEmpty(modelo.ContrasenaConfirmacion))
            {
                return new ValidationResult("Ingresa nuevamente la contraseña");
            }
            // Lógica de validación basada en otros campos del modelo
            if (modelo.Contrasena != modelo.ContrasenaConfirmacion)
            {
                return new ValidationResult("Las contraseñas no coinciden");
            }

            var password = modelo.Contrasena;

            // Validaciones de seguridad de la contraseña
            if (password.Length < 8)
            {
                return new ValidationResult("La contraseña debe tener al menos 8 caracteres.");
            }

            if (!Regex.IsMatch(password, @"[A-Z]"))
            {
                return new ValidationResult("La contraseña debe contener al menos una letra mayúscula.");
            }

            if (!Regex.IsMatch(password, @"[a-z]"))
            {
                return new ValidationResult("La contraseña debe contener al menos una letra minúscula.");
            }

            if (!Regex.IsMatch(password, @"[0-9]"))
            {
                return new ValidationResult("La contraseña debe contener al menos un número.");
            }

            if (!Regex.IsMatch(password, @"[\W_]"))
            {
                return new ValidationResult("La contraseña debe contener al menos un carácter especial.");
            }

            return ValidationResult.Success;
        }
    }
}
