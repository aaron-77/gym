namespace DTO.Dtos
{
    public class TestCredentialsForRealUsers
    {
        public List<Entry> Entries { get; set; } = new();

        public class Entry
        {
            public string Title { get; set; } = string.Empty;
            public string Email { get; set; } = string.Empty;
            public string Password { get; set; } = string.Empty;
        }
    }
}
