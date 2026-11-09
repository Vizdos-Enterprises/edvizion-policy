# Update Terraform Variable Composite Action

This action updates the default value of a Terraform string variable and automatically opens or updates a pull request against `main`.

## Usage Template

```yaml
name: Update Terraform Variable

on:
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  update:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          ref: main

      - name: Update Terraform Variable
        uses: vizdos-enterprises/edvizion-policy/actions/update-terraform-variable@main
        with:
          tf-path: infra/variables.tf
          variable: app_service_container-tag
          value: v2026.11.09.1
          token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| Input | Required | Description |
|---|---|---|
| `tf-path` | Yes | Path to the Terraform file |
| `variable` | Yes | Name of the Terraform variable |
| `value` | Yes | New string default value |
| `token` | No | GitHub token for creating the PR; defaults to `github.token` |

## Behavior

- Updates only the specified Terraform variable's string `default`.
- Opens or updates a pull request targeting `main`.
- Reuses the branch `automation/update-<variable>` for subsequent updates.
- Does not create a PR if there are no changes.
- Does not automatically merge or deploy changes.

## Requirements

The token must have `contents: write` and `pull-requests: write` permissions.

For release workflows triggered by Git tags, check out `main` before invoking this action so the PR includes the latest Terraform configuration.

Only string-valued Terraform defaults are supported.
