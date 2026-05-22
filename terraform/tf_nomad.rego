package terraform

import rego.v1

nomad_job_changes contains rc if {
	some rc in input.resource_changes
	rc.type == "nomad_job"
	rc.mode == "managed"
}

deny contains msg if {
	some rc in nomad_job_changes

	namespace := rc.change.after.namespace

	not namespace

	msg := sprintf(
		"nomad_job.%s must have a calculated namespace",
		[rc.name],
	)
}

deny contains msg if {
	some rc in nomad_job_changes

	namespace := rc.change.after.namespace

	namespace == "default"

	msg := sprintf(
		"nomad_job.%s must not deploy to default namespace",
		[rc.name],
	)
}

deny contains msg if {
	some rc in nomad_job_changes

	namespace := rc.change.after.namespace

	regex.match("\\$\\{[^}]+\\}", namespace)

	msg := sprintf(
		"nomad_job.%s namespace is still templated: %q",
		[rc.name, namespace],
	)
}

deny contains msg if {
	some rc in nomad_job_changes

	namespace := rc.change.after.namespace

	namespace == ""

	msg := sprintf(
		"nomad_job.%s namespace is empty",
		[rc.name],
	)
}
