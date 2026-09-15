# Go Private Composite Action

This action allows access to private Go modules.

## Usage Template

```yaml
name: Example Workflow

on:
  push:
    branches: [main]

permissions:
  contents: read
  id-token: write

# Demo
jobs:
  sbom:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v5

      - name: Setup Go Private
        uses: vizdos-enterprises/edvizion-policy/actions/go-private@main
```
