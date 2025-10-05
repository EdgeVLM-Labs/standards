# Org Standards

## Naming (Python-first)

- Repos: kebab-case
- Folders & Python files: snake_case
- Classes: UpperCamelCase
- Functions & variables: lower_snake_case
- Constants & ENV keys: UPPER_SNAKE_CASE
- Shell scripts: snake_case.sh

## Required files in every repo

- .editorconfig
- .gitignore
- .pre-commit-config.yaml
- .env.example (if env-based)
- README.md
- scripts/init_env.sh (optional)
- scripts/check_names.sh (enforce file/folder naming)

## Quality gates

- pre-commit must pass locally & in CI
- Required PR checks: precommit (lint/format/secrets), tests if any
- No direct pushes to main; PR + review required
- Secret scanning enabled
