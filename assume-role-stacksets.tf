locals {
  assume_role_stacksets = {
    "assume-role-stacksets" = {
      enabled = true
      settings = {
        regions = ["us-east-1",
           "us-west-2",
           "us-west-1",
           "us-east-2",         
        ]
        description = "Assume Role StackSets"
        template_file_name = "stackset-templates/assume-role-stacksets.yml"
        failure_tolerance_count = 1
        max_concurrent_count = 1
        organizational_unit_ids = local.all_ous
        account_ids = [984505168843]
        account_filter_type = "INTERSECTION"
    }
    }
  }
}