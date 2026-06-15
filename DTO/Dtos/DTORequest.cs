namespace DTO.Dtos
{
    public class DTORequest<T>
    {
        public Type type { get; set; }
        public T payload { get; set; }

    }
}