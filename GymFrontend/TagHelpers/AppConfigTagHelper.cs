using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Razor.TagHelpers;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace GymFrontend.TagHelpers
{
    [HtmlTargetElement("app-config")]
    public class AppConfigTagHelper : TagHelper
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<AppConfigTagHelper> _logger;

        [HtmlAttributeName("sections")]
        public string? Sections { get; set; }

        public AppConfigTagHelper(IConfiguration configuration, ILogger<AppConfigTagHelper> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        public override Task ProcessAsync(TagHelperContext context, TagHelperOutput output)
        {
            output.TagName = "script";
            output.Attributes.SetAttribute("type", "text/javascript");

            if (string.IsNullOrWhiteSpace(Sections))
            {
                _logger.LogWarning("AppConfig tag helper used without 'sections' attribute. No config exposed.");
                output.Content.SetHtmlContent("window.AppConfig = {};");
                return Task.CompletedTask;
            }

            var sectionNames = Sections.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            var configDict = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);

            foreach (var name in sectionNames)
            {
                var section = _configuration.GetSection(name);
                if (section.Exists())
                {
                    configDict[name] = ReadSection(section);
                }
            }

            var options = new JsonSerializerOptions { WriteIndented = false };
            string json = JsonSerializer.Serialize(configDict, options);

            output.Content.SetHtmlContent($"window.AppConfig = {json};");
            return Task.CompletedTask;
        }

        private static object ReadSection(IConfigurationSection section)
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
