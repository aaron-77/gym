# Specification for E2E Test Scenarios

## Purpose

Define the end-to-end test scenarios for the FitnessGym application using Playwright with Testcontainers. Each scenario follows the GIVEN/WHEN/THEN format and maps to critical user paths through the full application stack.

## Test Strategy

E2E tests cover **critical user paths only**. They are the slowest and most brittle test type in the pyramid. Follow the principle:

> More unit tests, fewer integration tests, fewest E2E tests.

### What E2E Tests Verify
- Full-stack integration (browser → Nginx → API → Database → Frontend → Browser)
- UI rendering and navigation flows
- Authentication and session management
- Critical business workflows visible to end users

### What E2E Tests Do NOT Verify
- Individual business logic rules (unit tests)
- Database stored procedure logic (integration/TSQL tests)
- API contract details (integration tests)
- Edge cases and validation messages (unit/integration tests)

## General Rules

### Rule: All E2E tests MUST inherit from PlaywrightTestBase
- This ensures containers are initialized before tests run
- Tests that only need HTTP (no browser) SHOULD be integration tests, not E2E

### Rule: Test credentials MUST come from appsettings.Testing.json
- NEVER hardcode email/password in test files
- Read from configuration via `IConfiguration` or a test settings helper
- Available test users:
  - `TestUser`: `uno@gmail.com` / `Password123*` (employee role)
  - `TestUserCliente`: `aaronhl1313@gmail.com` / `Password123*` (client role)

### Rule: Assertions MUST verify actual content, not just existence
- DO: `Expect(heading).ToHaveTextAsync(new Regex("Clases Programadas"))`
- DON'T: `await heading.WaitForAsync(...)` (only waits for visibility, doesn't verify content)
- DO: `Expect(page).ToHaveURLAsync(...)` with specific URL pattern
- DON'T: `Assert.NotNull(title)` with no content verification

### Rule: Test naming convention
- Format: `{Feature}_{Action}_{ExpectedResult}`
- Example: `Login_ValidCredentials_RedirectsToHomepage`
- Example: `Clases_NavigateToClasesPage_ShowsClassList`

### Rule: No derived tests
- ONLY implement tests explicitly defined in this specification
- Do NOT add edge cases or variations without proposing them first
- If you identify a missing scenario, propose it and wait for confirmation

---

## Scenario Group: Authentication

### Scenario: Login with valid credentials redirects to homepage

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | `Login_ValidCredentials_RedirectsToHomepage` | User `uno@gmail.com` exists with password `Password123*` (seeded data) | Navigate to `/signIn`, fill Email input with `uno@gmail.com`, fill Password input with `Password123*`, click "Iniciar Sesión" button | Page URL matches home pattern (`/` or `/home` or `/Index`), AND user session indicator is visible (e.g., user name or menu) |

#### Implementation notes:
- Use `Page.GetByLabel("Email")` and `Page.GetByLabel("Password")` for inputs
- Use `Page.GetByRole(AriaRole.Button, new() { Name = "Iniciar Sesión" })` for submit
- Use `Page.WaitForURLAsync(new Regex(".*(/|/?home|/?Index)", RegexOptions.IgnoreCase))` for redirect verification
- Verify session by checking for user-related element: `Page.GetByRole(AriaRole.Button).First` or similar

### Scenario: Login with invalid credentials shows error

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 2 | `Login_InvalidCredentials_ShowsError` | User `uno@gmail.com` exists with password `Password123*` | Navigate to `/signIn`, fill Email with `uno@gmail.com`, fill Password with `WrongPassword123!`, click "Iniciar Sesión" | Error message is visible containing text matching regex `(incorrect|inválid|error|credencial)`, AND page URL remains on `/signIn` (no redirect) |

#### Implementation notes:
- Use `Page.GetByText(new Regex("credenciales inválidas|incorrectas|error|inválid", RegexOptions.IgnoreCase))` for error verification
- Verify URL does NOT change: `Page.WaitForURLAsync` should timeout or URL should still contain `signIn`

---

## Scenario Group: Homepage

### Scenario: Homepage loads successfully

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 3 | `Homepage_LoadsSuccessfully` | Application is running (containers started) | Navigate to `http://localhost:5080` (Nginx proxy) | Page title contains text matching regex `(Fitness|Gym|Home|Inicio)`, AND page HTTP response status is 200 |

### Scenario: Homepage shows scheduled classes heading

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 4 | `Homepage_ShowsScheduledClasses` | Application is running with seeded class data | Navigate to `http://localhost:5080` | H1 heading is visible with text matching regex `(Clases|Programadas|Próximas|Horarios)`, AND at least one class-related element is visible |

### Scenario: Homepage navigation menu is visible

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 5 | `Homepage_NavigationMenuIsVisible` | Application is running | Navigate to `http://localhost:5080` | `<nav>` element is visible, AND link with text "Clase" or "Clases" is visible, AND link with text matching regex `(Home|Inicio)` is visible |

---

## Scenario Group: Navigation

### Scenario: Click on Clases link loads classes page

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 6 | `Navigation_ClickOnClasesLink_LoadsClasesPage` | User is on homepage | Click link with text "Clases" or "Clase" | Page URL matches pattern `.*/clases.*` (case insensitive), AND page contains class-related content |

### Scenario: Click on Horarios link loads schedules page

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 7 | `Navigation_ClickOnHorariosLink_LoadsHorariosPage` | User is on homepage | Click link with text "Horarios" | Page URL matches pattern `.*/horarios.*` (case insensitive), AND page contains schedule-related content |

### Scenario: Click on Home link returns to homepage from classes page

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 8 | `Navigation_ClickOnHomeLink_ReturnsToHomepage` | User is on `/clases` page | Click link with text "Home" or "Inicio" | Page URL matches pattern `.*(/|/?home|/?Index)` (case insensitive) |

---

## Scenario Group: API Health (Integration Test, NOT E2E)

> **NOTE:** These tests do NOT require Playwright or browser automation. They SHOULD be implemented as integration tests, not E2E tests. The scenarios are documented here for completeness but should live in `Integration/Features/Api/`.

### Scenario: API health endpoint returns healthy response

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 9 | `ApiHealth_GetHealthEndpoint_Returns200Ok` | API container is running (via TestContainerHelper) | Make GET request to `http://localhost:5274/health` | HTTP status code is 200 OK, AND response body is not empty |

### Scenario: API root endpoint returns success

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 10 | `ApiHealth_GetRootEndpoint_ReturnsSuccess` | API container is running | Make GET request to `http://localhost:5274/api` | HTTP status code is NOT 404 and NOT 500, AND response is not null |

---

## Proposed Additional Scenarios (Pending Approval)

The following scenarios are identified as critical paths NOT currently covered. They require user approval before implementation:

| # | Proposed Test Name | Description | Priority |
|---|-------------------|-------------|----------|
| P1 | `Clases_ViewClaseDetail_ShowsClassInfo` | Navigate to a specific class detail page and verify information displays correctly | Medium |
| P1 | `Clases_InscribeToClass_ValidUser_Succeeds` | Full enrollment flow: navigate to class, click enroll, verify confirmation | High |
| P2 | `PasswordChange_ChangePassword_ValidCredentials` | Full password change flow via user settings | Medium |
| P2 | `Trainers_ScheduleClass_CreatesScheduledClass` | Employee user creates a scheduled class (requires auth + form submission) | Medium |
| P3 | `Responsive_NavigationMenu_CollapsesOnMobile` | Navigation menu behavior on mobile viewport | Low |

> To approve any of these, confirm which scenarios to add and they will be formally added to this spec.

---

## Test Count Summary

| Group | Tests | Status |
|-------|-------|--------|
| Authentication | 2 | Approved |
| Homepage | 3 | Approved |
| Navigation | 3 | Approved |
| API Health | 2 | Approved (as integration tests) |
| **Total Approved** | **10** | |
| Proposed (pending) | 5 | Pending approval |
