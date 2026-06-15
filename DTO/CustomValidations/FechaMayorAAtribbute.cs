using System.ComponentModel.DataAnnotations;

namespace DTO.CustomValidations
{
    public class FechaMayorAAttribute : ValidationAttribute
    {
        private readonly DateTime _min;
        private string minValueForDateTypes = "01/01/0001 00:00:00";


        public FechaMayorAAttribute()
        {

            _min = DateTime.Today;
        }
        public FechaMayorAAttribute(string minDate = "01/01/0001 00:00:00")
        {
            if (minDate == minValueForDateTypes)
            {
                _min = DateTime.Today;
            }
            _min = DateTime.Parse(minDate);
        }
        

        protected override ValidationResult IsValid(
            object value,
            ValidationContext validationContext
        )
        {
            if (value is DateTime fecha && fecha < _min)
            {
                return new ValidationResult(
                    ErrorMessage ?? $"La fecha debe ser mayor o igual a {_min.ToShortDateString()}"
                );
            }

            return ValidationResult.Success;
        }
    }
}
