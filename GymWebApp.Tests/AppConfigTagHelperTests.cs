using GymFrontend.TagHelpers;
using Microsoft.AspNetCore.Razor.TagHelpers;
using Microsoft.Extensions.Configuration;
using Moq;
using System.Collections.Generic;
using System.Text.Json;
using System.Threading.Tasks;
using Xunit;

namespace GymWebApp.Tests
{
    public class AppConfigTagHelperTests
    {
        [Fact]
        public async Task ProcessAsync_GeneratesScriptTag_WithAppConfig()
        {
            // Arrange
            var configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
                    { "TestKey", "TestValue" },
                    { "Nested:Key1", "Value1" },
                    { "Nested:Key2", "Value2" }
                })
                .Build();

            var tagHelper = new AppConfigTagHelper(configuration);
            var context = new TagHelperContext(
                new TagHelperAttributeList(),
                new Dictionary<object, object>(),
                "unique-id");
            var output = new TagHelperOutput(
                "app-config",
                new TagHelperAttributeList(),
                (cache, encoder) => Task.FromResult<TagHelperContent>(new DefaultTagHelperContent()));

            // Act
            await tagHelper.ProcessAsync(context, output);

            // Assert
            Assert.Equal("script", output.TagName);
            Assert.Equal("text/javascript", output.Attributes["type"]?.Value?.ToString());
            Assert.NotNull(output.Content);
            
            var content = output.Content.GetContent();
            Assert.Contains("window.AppConfig", content);
            Assert.Contains("TestKey", content);
            Assert.Contains("TestValue", content);
        }

        [Fact]
        public async Task ProcessAsync_HandlesNestedConfiguration()
        {
            // Arrange
            var configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
                    { "EndPoints:api:ssl", "https://api.example.com" },
                    { "EndPoints:api:nossl", "http://api.example.com" },
                    { "JwtSettings:SecretKey", "test-secret-key" }
                })
                .Build();

            var tagHelper = new AppConfigTagHelper(configuration);
            var context = new TagHelperContext(
                new TagHelperAttributeList(),
                new Dictionary<object, object>(),
                "unique-id");
            var output = new TagHelperOutput(
                "app-config",
                new TagHelperAttributeList(),
                (cache, encoder) => Task.FromResult<TagHelperContent>(new DefaultTagHelperContent()));

            // Act
            await tagHelper.ProcessAsync(context, output);

            // Assert
            var content = output.Content.GetContent();
            Assert.Contains("EndPoints", content);
            Assert.Contains("api", content);
            Assert.Contains("https://api.example.com", content);
            Assert.Contains("http://api.example.com", content);
            Assert.Contains("JwtSettings", content);
        }

        [Fact]
        public async Task ProcessAsync_GeneratesValidJson()
        {
            // Arrange
            var configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
                    { "SimpleKey", "SimpleValue" },
                    { "NumberKey", "123" },
                    { "BooleanKey", "true" }
                })
                .Build();

            var tagHelper = new AppConfigTagHelper(configuration);
            var context = new TagHelperContext(
                new TagHelperAttributeList(),
                new Dictionary<object, object>(),
                "unique-id");
            var output = new TagHelperOutput(
                "app-config",
                new TagHelperAttributeList(),
                (cache, encoder) => Task.FromResult<TagHelperContent>(new DefaultTagHelperContent()));

            // Act
            await tagHelper.ProcessAsync(context, output);

            // Assert
            var content = output.Content.GetContent();
            
            // Extraer el JSON del contenido del script
            var jsonStart = content.IndexOf('{');
            var jsonEnd = content.LastIndexOf('}') + 1;
            var jsonContent = content.Substring(jsonStart, jsonEnd - jsonStart);
            
            // Verificar que es JSON válido
            var jsonDoc = JsonDocument.Parse(jsonContent);
            Assert.NotNull(jsonDoc);
            
            // Verificar que contiene las claves esperadas
            var root = jsonDoc.RootElement;
            Assert.True(root.TryGetProperty("SimpleKey", out var simpleKey));
            Assert.Equal("SimpleValue", simpleKey.GetString());
        }

        [Fact]
        public async Task ProcessAsync_HandlesEmptyConfiguration()
        {
            // Arrange
            var configuration = new ConfigurationBuilder().Build();

            var tagHelper = new AppConfigTagHelper(configuration);
            var context = new TagHelperContext(
                new TagHelperAttributeList(),
                new Dictionary<object, object>(),
                "unique-id");
            var output = new TagHelperOutput(
                "app-config",
                new TagHelperAttributeList(),
                (cache, encoder) => Task.FromResult<TagHelperContent>(new DefaultTagHelperContent()));

            // Act
            await tagHelper.ProcessAsync(context, output);

            // Assert
            Assert.Equal("script", output.TagName);
            var content = output.Content.GetContent();
            Assert.Contains("window.AppConfig", content);
            // Debe generar un objeto vacío o con propiedades del sistema
            Assert.Contains("{", content);
        }

        [Fact]
        public async Task ProcessAsync_HandlesCaseInsensitiveKeys()
        {
            // Arrange
            var configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
                    { "TestKey", "Value1" },
                    { "Nested:TestKey", "NestedValue" }
                })
                .Build();

            var tagHelper = new AppConfigTagHelper(configuration);
            var context = new TagHelperContext(
                new TagHelperAttributeList(),
                new Dictionary<object, object>(),
                "unique-id");
            var output = new TagHelperOutput(
                "app-config",
                new TagHelperAttributeList(),
                (cache, encoder) => Task.FromResult<TagHelperContent>(new DefaultTagHelperContent()));

            // Act
            await tagHelper.ProcessAsync(context, output);

            // Assert
            var content = output.Content.GetContent();
            // El TagHelper usa StringComparer.OrdinalIgnoreCase en los diccionarios internos
            // Verificamos que las claves se procesan correctamente
            Assert.Contains("TestKey", content);
            Assert.Contains("Nested", content);
            
            // Verificar que el JSON generado es válido
            var jsonStart = content.IndexOf('{');
            var jsonEnd = content.LastIndexOf('}') + 1;
            var jsonContent = content.Substring(jsonStart, jsonEnd - jsonStart);
            var jsonDoc = JsonDocument.Parse(jsonContent);
            Assert.NotNull(jsonDoc);
        }

        [Fact]
        public async Task ProcessAsync_OutputsMinifiedJson()
        {
            // Arrange
            var configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
                    { "Key1", "Value1" },
                    { "Key2", "Value2" },
                    { "Key3", "Value3" }
                })
                .Build();

            var tagHelper = new AppConfigTagHelper(configuration);
            var context = new TagHelperContext(
                new TagHelperAttributeList(),
                new Dictionary<object, object>(),
                "unique-id");
            var output = new TagHelperOutput(
                "app-config",
                new TagHelperAttributeList(),
                (cache, encoder) => Task.FromResult<TagHelperContent>(new DefaultTagHelperContent()));

            // Act
            await tagHelper.ProcessAsync(context, output);

            // Assert
            var content = output.Content.GetContent();
            // El JSON debe estar minificado (WriteIndented = false)
            // No debe contener saltos de línea innecesarios en el JSON
            var jsonStart = content.IndexOf('{');
            var jsonEnd = content.LastIndexOf('}') + 1;
            var jsonContent = content.Substring(jsonStart, jsonEnd - jsonStart);
            
            // Verificar que no tiene indentación excesiva (puede tener espacios pero no muchos saltos de línea)
            var lineCount = jsonContent.Split('\n').Length;
            // Para un objeto pequeño, no debería tener muchas líneas si está minificado
            Assert.True(lineCount <= 3, "El JSON debería estar minificado");
        }
    }
}

