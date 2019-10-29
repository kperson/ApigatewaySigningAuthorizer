---
to: Build/variables.tf
unless_exists: true
sh: cd Build && terraform fmt
---
variable "swift_layer" {
  default = "arn:aws:lambda:us-east-1:193125195061:layer:swift5:17"
}

variable "namespace" {
  type = "string"
  default = "prod"
}

