---
to: Build/resource_dynamo_<%=locals.table%>.tf
unless_exists: true
sh: cd Build && terraform fmt
---
module "dynamo_<%=locals.table%>" {
  source           = "github.com/kperson/terraform-modules//auto-scaled-dynamo"
  table_name       = "${var.namespace}_<%=locals.table%>"
  <% if(locals.hash_key){ -%>
  hash_key         = "<%=hash_key%>"
  <% } -%>
  <% if(locals.range_key){ -%>
  range_key        = "<%=range_key%>"
  <% } -%>
  stream_view_type = "NEW_AND_OLD_IMAGES"
  <% if(locals.range_key && locals.hash_key){ -%>
  attributes = [
    {
      name = "<%=hash_key%>"
      type = "<%=locals.hash_key_type%>"
    },
    {
      name = "<%=range_key%>"
      type = "<%=locals.range_key_type%>"
    }
  ]
  <% } -%>
  <% if(locals.hash_key && !locals.range_key){ -%>
  attributes = [
    {
      name = "<%=hash_key%>"
      type = "<%=locals.hash_key_type%>"
    }
  ]
  <% } -%>

  <% if(locals.ttl_attribute){ -%>
  ttl {
    attribute_name = "<%=ttl_attribute%>"
    enabled        = true
  }
  <% } -%>
}

module "dynamo_<%=locals.table%>_policy" {
  source     = "github.com/kperson/terraform-modules//dynamo-crud-policy"
  table_arn  = "${module.dynamo_<%=locals.table%>.arn}"
  stream_arn = "${module.dynamo_<%=locals.table%>.stream_arn}"
}

resource "aws_iam_role_policy_attachment" "dynamo_<%=locals.table%>" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${module.dynamo_<%=locals.table%>_policy.arn}"
}

#TABLE_NAME/ID  = "${module.dynamo_<%=locals.table%>.id}"
