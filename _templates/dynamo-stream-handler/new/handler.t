---
inject: true
to: Build/events.tf
after: //Auto-generated Events
skip_if: module "dynamo_stream_<%=locals.table%>_handler" {
sh: cd Build && terraform fmt
---
module "dynamo_stream_<%=locals.table%>_handler" {
  source        = "github.com/kperson/swift-lambda-tools//terraform/dynamo-stream-lambda"
  build_params  = "${local.build_params}"
  env           = "${local.env}"
  function_name = "${var.namespace}_<%=locals.handler.replace(/\./g, '_')%>"
  handler       = "<%=locals.handler%>"
  stream_arn    = "${module.dynamo_<%=locals.table%>.stream_arn}"
}
