---
inject: true
to: Build/events.tf
after: //Auto-generated Events
skip_if: module "api_<%=locals.api%>_handler" {
sh: cd Build && terraform fmt
---

module "api_<%=locals.api%>_handler" {
  source               = "github.com/kperson/swift-lambda-tools//terraform/http-lambda"
  build_params         = "${local.build_params}"
  env                  = "${local.env}"
  function_name        = "${var.namespace}_<%=locals.handler.replace(/\./g, '_')%>"
  handler              = "<%=locals.handler%>"
  stage_name           = "default"
  api_id               = "${aws_api_gateway_rest_api.<%=locals.api%>.id}"
  api_root_resource_id = "${aws_api_gateway_rest_api.<%=locals.api%>.root_resource_id}"
}
