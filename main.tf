##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

module "mongoatlas_users" {
  source = "git::https://github.com/cloudopsworks/terraform-module-mongoatlas-users.git?ref=v1.4.0"

  is_hub     = var.is_hub
  spoke_def  = var.spoke_def
  org        = var.org
  extra_tags = var.extra_tags

  name_prefix                 = var.name_prefix
  project_id                  = var.project_id
  project_name                = var.project_name
  users                       = var.users
  hoop                        = var.hoop
  force_reset                 = var.force_reset
  password_rotation_period    = var.password_rotation_period
  region                      = data.aws_region.current.id
  password_externally_managed = var.rotation_lambda_name != ""
}
