##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#
# State migration blocks: when replacing terraform-module-mongoatlas-users with this module,
# these moved blocks remap resources that moved into the generic mongoatlas_users submodule.
# AWS Secrets Manager resources remain at the same path and require no moved blocks.
# Hoop resources are excluded from migration.
#

moved {
  from = mongodbatlas_database_user.this
  to   = module.mongoatlas_users.mongodbatlas_database_user.this
}

moved {
  from = random_password.randompass
  to   = module.mongoatlas_users.random_password.randompass
}

moved {
  from = random_password.randompass_rotated
  to   = module.mongoatlas_users.random_password.randompass_external
}

moved {
  from = time_rotating.randompass
  to   = module.mongoatlas_users.time_rotating.randompass
}
