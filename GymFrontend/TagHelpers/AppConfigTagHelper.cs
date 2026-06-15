using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Razor.TagHelpers;
using Microsoft.Extensions.Configuration;

namespace GymFrontend.TagHelpers
{
    [HtmlTargetElement("app-config")]
    public class AppConfigTagHelper : TagHelper
    {
        private readonly IConfiguration _configuration;

        public AppConfigTagHelper(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public override Task ProcessAsync(TagHelperContext context, TagHelperOutput output)
        {
            output.TagName = "script";
            output.Attributes.SetAttribute("type", "text/javascript");

            var configDict = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            foreach (var child in _configuration.GetChildren())
            {
                configDict[child.Key] = ReadSection(child);
            }

            var options = new JsonSerializerOptions { WriteIndented = false };
            string json = JsonSerializer.Serialize(configDict, options);

            string script = $"window.AppConfig = {json};";

            output.Content.SetHtmlContent(script);
            return Task.CompletedTask;
        }

        private object ReadSection(IConfigurationSection section)
        {
            if (section.GetChildren().Any())
            {
                var dict = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                foreach (var child in section.GetChildren())
                {
                    dict[child.Key] = ReadSection(child);
                }
                return dict;
            }
            return section.Value;
        }
    }
}
