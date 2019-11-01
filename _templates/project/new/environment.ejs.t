---
to: Build/environment.tf
unless_exists: true
sh: cd Build && terraform fmt
---
locals {
  env = {
    LOG_LEVEL = "WARN"
    MODE      = "lambda"
  }
}