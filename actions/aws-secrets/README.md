# AWS Secrets Composite Action

This action allows access to AWS secrets defined in SSM.

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

      - name: Load credentials
        uses: vizdos-enterprises/edvizion-policy/actions/aws-secrets@main
        with:
          parameters: |
            DEPENDENCY_TRACK_API_TOKEN=/github/shared/dependency-track/api-token
            DEPENDENCY_TRACK_HOSTNAME=/github/shared/dependency-track/hostname
```
