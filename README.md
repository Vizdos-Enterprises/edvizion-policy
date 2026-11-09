
# Edvizion Policy

Shared configuration, security policies, and reusable GitHub Actions for Edvizion projects.

This repository centralizes common CI/CD workflows, dependency management configuration, infrastructure policies, and security tooling to promote consistency across repositories.

## Reusable GitHub Actions

| Action | Description |
| --- | --- |
| [AWS Secrets](./actions/aws-secrets/README.md) | Retrieve AWS secrets for CI/CD workflows. |
| [Conftest](./actions/conftest/action.yml) | Validate configuration against policy-as-code rules. |
| [Dependency Track](./actions/dependency-track/README.md) | Integrate dependency and SBOM analysis with Dependency-Track. |
| [Go Private](./actions/go-private/README.md) | Configure access to private Go modules. |
| [Update Terraform Variable](./actions/update-terraform-variable/README.md) | Update Terraform variables and automate pull requests. |

### Usage

Actions can be referenced directly from other repositories:

```yaml
steps:
  - name: Configure private Go modules
    uses: Vizdos-Enterprises/edvizion-policy/actions/go-private@main
```

For production workflows, consider pinning actions to a commit SHA rather than `main`.

See each action's documentation for available inputs and examples.

## Renovate

Shared Renovate configuration lives in [`renovate/`](./renovate/).

Projects can extend the central configuration instead of maintaining duplicate dependency update rules.

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>Vizdos-Enterprises/edvizion-policy//renovate/base"
  ]
}
```

See the [Renovate README](./renovate/README.md) for configuration details.

## Infrastructure Policies

Infrastructure policies are implemented using [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) and Rego.

| Policy | Location |
| --- | --- |
| Nomad | [nomad.rego](./.edvizion-policy/nomad/nomad.rego) |
| Terraform / Nomad | [tf_nomad.rego](./.edvizion-policy/terraform/tf_nomad.rego) |

These policies can be evaluated through Conftest to validate infrastructure configuration before deployment.

## Testing

The repository includes GitHub Actions workflows for validating reusable integrations.

| Workflow | Purpose |
| --- | --- |
| `test-dependency-track.yml` | Test the Dependency-Track integration. |
| `test-go-private.yml` | Test private Go module authentication. |
| `test-secrets.yml` | Test secrets integration. |

Test fixtures are available in [`test/fixtures/`](./test/fixtures/).

## Repository Structure

```text
edvizion-policy/
├── .edvizion-policy/
│   ├── nomad/
│   │   └── nomad.rego
│   └── terraform/
│       └── tf_nomad.rego
├── .github/
│   └── workflows/
├── actions/
│   ├── aws-secrets/
│   ├── conftest/
│   ├── dependency-track/
│   ├── go-private/
│   └── update-terraform-variable/
├── renovate/
│   ├── base.json
│   └── README.md
├── test/
│   └── fixtures/
│       └── go-sbom/
└── README.md
```

## Contributing

Changes to this repository may affect multiple downstream projects.

When modifying shared configurations or actions:

1. Validate changes using the available test workflows.
2. Maintain backward compatibility where practical.
3. Update the relevant documentation.
4. Review the impact on downstream repositories before merging.

## License

Internal Edvizion tooling and configuration.
