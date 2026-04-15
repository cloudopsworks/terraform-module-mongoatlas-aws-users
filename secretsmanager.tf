##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  name_list = {
    for k in keys(var.users) : k => format("%s/mongodbatlas/%s/%s-connstrings",
      local.secret_store_path,
      lower(replace(replace(module.mongoatlas_users.users[k].project_name, " ", ""), "_", "-")),
      lower(replace(k, "_", "-")),
    )
  }
}

resource "aws_secretsmanager_secret" "atlas_cred_conn" {
  for_each    = var.users
  description = "MongoDB User Credentials - ${module.mongoatlas_users.users[each.key].username} - ${module.mongoatlas_users.users[each.key].project_name}${try(var.users[each.key].connection_strings.database_name, "") != "" ? format(" - %s", var.users[each.key].connection_strings.database_name) : ""}"
  name        = local.name_list[each.key]
  kms_key_id  = var.secrets_kms_key_id
  tags = merge(local.all_tags, {
    "mongodb-username" = module.mongoatlas_users.users[each.key].username
    "mongodb-project"  = module.mongoatlas_users.users[each.key].project_name
    },
    try(var.users[each.key].connection_strings.database_name, "") != "" ? { "mongodb-dbname" = try(var.users[each.key].connection_strings.database_name, "") } : {}
  )
  depends_on = [module.mongoatlas_users]
}

resource "aws_secretsmanager_secret_version" "atlas_cred_conn" {
  for_each = {
    for k, v in var.users : k => v if var.rotation_lambda_name == ""
  }
  secret_id      = aws_secretsmanager_secret.atlas_cred_conn[each.key].id
  secret_string  = jsonencode(module.mongoatlas_users.credentials[each.key])
  version_stages = ["AWSCURRENT"]
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_secretsmanager_secrets" "atlas_cred_conn_rotated" {
  for_each = {
    for k, v in var.users : k => v if var.rotation_lambda_name != ""
  }
  filter {
    name   = "name"
    values = [local.name_list[each.key]]
  }
}

data "aws_secretsmanager_secret_versions" "atlas_cred_conn_rotated" {
  for_each = {
    for k, v in var.users : k => v if var.rotation_lambda_name != "" && length(try(data.aws_secretsmanager_secrets.atlas_cred_conn_rotated[k].names, [])) > 0
  }
  secret_id          = local.name_list[each.key]
  include_deprecated = true
}

data "aws_secretsmanager_secret_version" "atlas_cred_conn_rotated" {
  for_each = {
    for k, v in var.users : k => v if var.rotation_lambda_name != "" && length(try(data.aws_secretsmanager_secrets.atlas_cred_conn_rotated[k].names, [])) > 0 && length(try(data.aws_secretsmanager_secret_versions.atlas_cred_conn_rotated[k].versions, [])) > 0
  }
  secret_id = local.name_list[each.key]
}

data "aws_lambda_function" "rotation_function" {
  count         = var.rotation_lambda_name != "" ? 1 : 0
  function_name = var.rotation_lambda_name
}

resource "aws_secretsmanager_secret_version" "atlas_cred_conn_rotated" {
  for_each = {
    for k, v in var.users : k => v if var.rotation_lambda_name != ""
  }
  secret_id      = aws_secretsmanager_secret.atlas_cred_conn[each.key].id
  secret_string  = jsonencode(module.mongoatlas_users.credentials[each.key])
  version_stages = ["AWSCURRENT"]
  lifecycle {
    ignore_changes = [
      secret_string,
      version_stages
    ]
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_rotation" "atlas_cred_conn_rotation" {
  for_each = {
    for k, v in var.users : k => v if var.rotation_lambda_name != ""
  }
  secret_id           = aws_secretsmanager_secret.atlas_cred_conn[each.key].id
  rotation_lambda_arn = data.aws_lambda_function.rotation_function[0].arn
  rotate_immediately  = var.rotate_immediately
  rotation_rules {
    automatically_after_days = var.password_rotation_period
    duration                 = var.rotation_duration
  }
  depends_on = [aws_secretsmanager_secret_version.atlas_cred_conn_rotated]
}
