---
inject: true
to: Build/role.tf
after: depends_on = \[
skip_if: dynamo_<%=locals.table%>
sh: cd Build && terraform fmt
---
 "aws_iam_role_policy_attachment.dynamo_<%=locals.table%>",
