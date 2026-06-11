package nomad

import rego.v1

#
# Require datacenters
#

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	not job.datacenters

	msg := sprintf(
		"Job %q must define at least one datacenter",
		[job_name],
	)
}

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	count(job.datacenters) == 0

	msg := sprintf(
		"Job %q must define at least one datacenter",
		[job_name],
	)
}

#
# Require resource limits on every task
#

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	some group_name, groups in job.group
	some group in groups

	some task_name, tasks in group.task
	some task in tasks

	not task.resources

	msg := sprintf(
		"Task %q in group %q must define resources",
		[task_name, group_name],
	)
}

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	some group_name, groups in job.group
	some group in groups

	some task_name, tasks in group.task
	some task in tasks

	not task.resources[0].cpu

	msg := sprintf(
		"Task %q in group %q must define cpu",
		[task_name, group_name],
	)
}

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	some group_name, groups in job.group
	some group in groups

	some task_name, tasks in group.task
	some task in tasks

	not task.resources[0].memory

	msg := sprintf(
		"Task %q in group %q must define memory",
		[task_name, group_name],
	)
}

#
# Ban host volumes
#

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	some group_name, groups in job.group
	some group in groups

	some volume_name, volumes in group.volume
	some volume in volumes

	volume.type == "host"

	msg := sprintf(
		"Job %q group %q volume %q uses forbidden host volume",
		[job_name, group_name, volume_name],
	)
}

#
# Require health checks on every service
#

is_upstreams_only_connect_service(service) if {
	service.connect
	service.connect[0].sidecar_service
	service.connect[0].sidecar_service[0].proxy
	service.connect[0].sidecar_service[0].proxy[0].upstreams
	count(service.connect[0].sidecar_service[0].proxy[0].upstreams) > 0
}

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	some group_name, groups in job.group
	some group in groups

	some service in group.service

	not is_upstreams_only_connect_service(service)
	not service.check

	msg := sprintf(
		"Service in job %q group %q must define a health check",
		[job_name, group_name],
	)
}

deny contains msg if {
	some job_name, jobs in input.job
	some job in jobs

	some group_name, groups in job.group
	some group in groups

	some service in group.service

	not is_upstreams_only_connect_service(service)
	count(service.check) == 0

	msg := sprintf(
		"Service in job %q group %q must define a health check",
		[job_name, group_name],
	)
}
