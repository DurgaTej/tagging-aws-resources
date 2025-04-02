locals {
  stacksets = merge(
    #local.tagging_aws_config_config_rule_stacksets,
    #local.tagging_custom_lambda_stackset,
    local.assume_role_stacksets
  )
}