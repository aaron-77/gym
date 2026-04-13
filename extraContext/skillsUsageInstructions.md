## Skills (Auto-load based on context)

IMPORTANT: When you detect any of these contexts, IMMEDIATELY read the corresponding skill file BEFORE writing any code. These are your coding standards.

### Skills usage based in Framework/Library Detection

| Context | Skill File |
|---------|------------|
| xUnit Unit Tests | [.opencode/skills/xunit-dotnet/SKILL.md](.opencode/skills/xunit-dotnet/SKILL.md) |
| xUnit Integration Tests | [.opencode/skills/xunit-integration/SKILL.md](.opencode/skills/xunit-integration/SKILL.md) |
| Playwright E2E (.NET) | [/home/aaron/.config/opencode/skills/dotnet-playwright/SKILL.md](/home/aaron/.config/opencode/skills/dotnet-playwright/SKILL.md) |
| .NET UI Testing Core | [/home/aaron/.config/opencode/skills/dotnet-ui-testing-core/SKILL.md](/home/aaron/.config/opencode/skills/dotnet-ui-testing-core/SKILL.md) | Page Object Model, selectores, wait strategies |
| .NET Testing Strategy | [/home/aaron/.config/opencode/skills/dotnet-testing-strategy/SKILL.md](/home/aaron/.config/opencode/skills/dotnet-testing-strategy/SKILL.md) | Unit vs Integration vs E2E decision tree |
| .NET Add Testing | [/home/aaron/.config/opencode/skills/dotnet-add-testing/SKILL.md](/home/aaron/.config/opencode/skills/dotnet-add-testing/SKILL.md) | Test project scaffolding |
| SQL Server DB Testing | [.opencode/skills/sqlserver-dbtesting/SKILL.md](.opencode/skills/sqlserver-dbtesting/SKILL.md) |
| React | [.opencode/skills/react-19/SKILL.md](.opencode/skills/react-19/SKILL.md) |
| Next.js | [.opencode/skills/nextjs-15/SKILL.md](.opencode/skills/nextjs-15/SKILL.md) |
| TypeScript | [.opencode/skills/typescript/SKILL.md](.opencode/skills/typescript/SKILL.md) |
| Tailwind | [.opencode/skills/tailwind-4/SKILL.md](.opencode/skills/tailwind-4/SKILL.md) |
| Zod | [.opencode/skills/zod-4/SKILL.md](.opencode/skills/zod-4/SKILL.md) |
| Zustand | [.opencode/skills/zustand-5/SKILL.md](.opencode/skills/zustand-5/SKILL.md) |
| AI SDK | [.opencode/skills/ai-sdk-5/SKILL.md](.opencode/skills/ai-sdk-5/SKILL.md) |
| Django DRF | [.opencode/skills/django-drf/SKILL.md](.opencode/skills/django-drf/SKILL.md) |
| Angular Core | [.opencode/skills/angular/core/SKILL.md](.opencode/skills/angular/core/SKILL.md) |
| Angular Forms | [.opencode/skills/angular/forms/SKILL.md](.opencode/skills/angular/forms/SKILL.md) |
| Angular Performance | [.opencode/skills/angular/performance/SKILL.md](.opencode/skills/angular/performance/SKILL.md) |
| Angular Architecture | [.opencode/skills/angular/architecture/SKILL.md](.opencode/skills/angular/architecture/SKILL.md) |
| Pytest | [.opencode/skills/pytest/SKILL.md](.opencode/skills/pytest/SKILL.md) |
| Playwright (generic) | [.opencode/skills/playwright/SKILL.md](.opencode/skills/playwright/SKILL.md) |
| Jira Task | [.opencode/skills/jira-task/SKILL.md](.opencode/skills/jira-task/SKILL.md) |
| Jira Epic | [.opencode/skills/jira-epic/SKILL.md](.opencode/skills/jira-epic/SKILL.md) |
| GitHub PR | [.opencode/skills/github-pr/SKILL.md](.opencode/skills/github-pr/SKILL.md) |
| Skill Creator | [.opencode/skills/skill-creator/SKILL.md](.opencode/skills/skill-creator/SKILL.md) |
| Bogus Factory | [.opencode/skills/bogus-factory/SKILL.md](.opencode/skills/bogus-factory/SKILL.md) |
| Integration Test Base | [.opencode/skills/integration-test-base/SKILL.md](.opencode/skills/integration-test-base/SKILL.md) |
| Test Helper | [.opencode/skills/test-helper/SKILL.md](.opencode/skills/test-helper/SKILL.md) |

### How to use skills

1. Detect context from user request or current file being edited
2. Read the relevant SKILL.md file(s) BEFORE writing code
3. Apply ALL patterns and rules from the skill
4. Multiple skills can apply (e.g., react-19 + typescript + tailwind-4)
