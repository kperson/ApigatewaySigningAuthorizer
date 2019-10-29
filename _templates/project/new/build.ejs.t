---
to: Build/build.tf
unless_exists: true
sh: cd Build && terraform fmt
---
module "build" {
  source              = "github.com/kperson/swift-lambda-tools//terraform/swift-build"
  working_dir         = "../"
  executable_location = "/code/.lambda-build/x86_64-unknown-linux/release/<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>"
}
