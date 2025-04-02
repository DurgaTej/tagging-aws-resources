module "cf_stacksets" {
    for_each = { for k, v in local.stacksets : k=> v if v.enabled }
    source = "./modules/cloudformation"

    name = each.key
    settings = each.value.settings
}