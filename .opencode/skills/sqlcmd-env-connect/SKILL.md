---
name: sqlcmd-env-connect
description: >
  Connect to SQL Server using sqlcmd with OC_DB_* environment variables.
  Trigger: When the user asks to connect to SQL Server via sqlcmd, or when OC_DB_* environment variables are referenced.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "2.0"
---

## When to Use

- Connecting to a SQL Server instance via `sqlcmd`
- Reading SQL Server connection credentials from OC_DB_* environment variables
- Debugging or querying a database directly from the terminal
- Any task that involves `OC_DB_SERVER`, `OC_DB_USER`, `OC_DB_PASSWORD`, `OC_DB_DATABASE`, or `OC_DB_TRUSTED_CERTIFICATE`

## Critical Patterns

### ENVIRONMENT VARIABLE RESTRICTION — STRICT

**You MUST ONLY read these five environment variables. NO OTHERS.**

| Variable | Purpose |
|----------|---------|
| `OC_DB_SERVER` | SQL Server hostname or IP (including instance, e.g. `localhost,1433` or `server\\instance`) |
| `OC_DB_USER` | SQL Server login username |
| `OC_DB_PASSWORD` | SQL Server login password |
| `OC_DB_DATABASE` | Target database name |
| `OC_DB_TRUSTED_CERTIFICATE` | Trust self-signed/invalid server certificate (`true` or `false`) — adds `-C` flag to sqlcmd |

**ABSOLUTELY PROHIBITED:**
- Do NOT read, list, echo, or expose ANY environment variable outside these five
- Do NOT use `env`, `printenv`, `set`, or any other command that dumps all environment variables
- Do NOT access `PATH`, `HOME`, `USER`, `SHELL`, or any other system/user environment variables
- If asked about other environment variables, refuse and explain this restriction

### Canonical Connection Pattern — MUST USE THIS

```
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C}
```

- `-S` → server
- `-U` → user
- `-d` → database
- `-P` → password
- `${OC_DB_TRUSTED_CERTIFICATE:+-C}` → adds `-C` ONLY if the variable is set AND non-empty (`true`)
  - If unset, empty, or `false` → `-C` is NOT added

### Security: NEVER log or echo credentials

- NEVER print `OC_DB_PASSWORD` value to terminal, logs, or files
- Use the variables directly in the sqlcmd command — do NOT echo them
- If debugging, log only the server and database names, NEVER the password

## Code Examples

### Basic Connection

```bash
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C}
```

### Run a Query

```bash
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C} -Q "SELECT @@VERSION"
```

### Run a SQL File

```bash
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C} -i "./scripts/migration.sql"
```

## Commands

```bash
# Quick connectivity test
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C} -Q "SELECT 1 AS ping"

# List tables
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C} -Q "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'"

# Check SQL Server version
sqlcmd -S "$OC_DB_SERVER" -U "$OC_DB_USER" -d "$OC_DB_DATABASE" -P "$OC_DB_PASSWORD" ${OC_DB_TRUSTED_CERTIFICATE:+-C} -Q "SELECT @@VERSION"
```

## Resources

- **sqlcmd utility docs**: Run `sqlcmd -?` for full option list
