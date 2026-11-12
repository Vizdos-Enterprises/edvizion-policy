# Semaphore Runner Composite Action

This action triggers Ansible playbooks through Semaphore UI's REST API using credentials stored in AWS SSM.

It supports dynamic project IDs, task templates, variables, and optional task completion monitoring.

## Usage Template

```yaml
name: Deploy ADM Relay

on:
  workflow_dispatch:

permissions:
  contents: read
  id-token: write

concurrency:
  group: adm-relay-deploy
  cancel-in-progress: false
  
jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy via Semaphore
        uses: vizdos-enterprises/edvizion-policy/actions/semaphore-runner@main
        with:
          project-id: "1"
          template-id: "5"
          variables: |
            {
              "service_name": "adm_relay",
              "image_tag": "v2026.11.12"
            }
          message: "Deploy ADM Relay v2026.11.12"
          wait: "true"
```

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `project-id` | Yes | — | Semaphore project ID |
| `template-id` | Yes | — | Semaphore task template ID |
| `variables` | No | `{}` | JSON object containing Ansible variables |
| `message` | No | `Triggered by GitHub Actions` | Task execution message |
| `wait` | No | `true` | Wait for task completion |
| `timeout` | No | `900` | Maximum wait time in seconds |
| `poll-interval` | No | `10` | Seconds between status checks |

## Outputs

| Output | Description |
|---|---|
| `task-id` | ID of the triggered Semaphore task |
| `task-url` | URL to view the task in Semaphore |
| `status` | Task status (`success`, `error`, `stopped`, `timeout`, etc.) |

## Authentication

Credentials are automatically retrieved using the [AWS Secrets Composite Action](../aws-secrets/README.md).

The following AWS SSM parameters must exist:

- `/github/shared/semaphore/api-token`
- `/github/shared/semaphore/hostname`

The GitHub Actions workflow must grant `id-token: write` permission and have access to the relevant AWS SSM parameters.

## Behavior

By default, the action waits for the Semaphore task to finish.

- **Success:** The GitHub Actions step succeeds.
- **Failure:** The GitHub Actions step fails.
- **Timeout:** The GitHub Actions step fails without canceling the Semaphore task.
- **`wait: "false"`:** The step succeeds once the task is created, without waiting for completion.

Variables are provided as a JSON object, allowing the same action to trigger different Semaphore playbooks without modification.
