---
to: Build/events.tf
unless_exists: true
sh: cd Build && terraform fmt
---
locals {
  build_params = {
    zip_file      = "${module.build.zip_file}"
    zip_file_hash = "${module.build.zip_file_hash}"
    runtime_layer = "${var.swift_layer}"
    role          = "${data.template_file.role_arn.rendered}"
  }
}

output "docker_tag" {
  value = "${module.build.docker_tag}"
}

//Auto-generated Events
