##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name_prefix" {
  description = <<-EOD
  name_prefix: "atlas" # (Required) Prefix used to compose usernames when `users[<key>].username` is not provided. Allowed: lowercase letters, numbers, and hyphens. No default.
  EOD
  type        = string
}

variable "project_id" {
  description = <<-EOD
  project_id: "60f0f0f0f0f0f0f0f0f0f0f0" # (Optional) Atlas Project ID. One of `project_id` or `project_name` must be provided. Default: "".
  EOD
  type        = string
  default     = ""
}

variable "project_name" {
  description = <<-EOD
  project_name: "my-project" # (Optional) Atlas Project Name. One of `project_id` or `project_name` must be provided. Default: "".
  EOD
  type        = string
  default     = ""
}

variable "users" {
  description = <<-EOD
  users:
    <user_key>:
      username: "user1" # (Optional) Explicit username. If omitted, composed as `<name_prefix|user.name_prefix>-<system_name_short>-<user_key>`. Default: generated.
      name_prefix: "prefix1" # (Optional) Per-user prefix to build the username. If omitted, uses var.name_prefix. Default: null.
      auth_database: "admin" # (Optional) Authentication database. Common: "admin". Default: "admin".
      password_rotation_period: 90 # (Optional) Rotation period in days for this user. Overrides var.password_rotation_period. Default: var.password_rotation_period.
      import: false # (Optional) When true, imports an existing MongoDB Atlas user instead of creating a new one. Default: false.
      role_name: "readwrite" # (Optional) Top-level primary role key used for Hoop connection naming. Allowed: readwrite, read, dbadmin, admin, dbowner, owner, clusteradmin. Default: "default".
      roles: # (Required) MongoDB roles granted to this user.
        - role_name: "readWrite" # (Required) Built-in or custom role name. Common: read, readWrite, dbAdmin, dbOwner, userAdmin, clusterAdmin. No default.
          database_name: "test" # (Required) Database that the role applies to. No default.
          collection_name: "widgets" # (Optional) Collection the role is scoped to. Default: null.
      scopes: # (Optional) Atlas scope bindings for the user.
        - name: "cluster-name" # (Required) Target cluster or data lake name. No default.
          type: "CLUSTER" # (Optional) Scope type. Allowed: CLUSTER, DATA_LAKE. Default: "CLUSTER".
      connection_strings: # (Optional) Control generation of connection strings in Secrets Manager.
        enabled: false # (Optional) When true, store connection strings. Default: false.
        cluster: "cluster0" # (Required if enabled) Atlas Cluster name. No default.
        endpoint_id: "vpce-0123456789abcdef" # (Optional) Private endpoint ID for PrivateLink strings. Default: "".
        database_name: "mydatabase" # (Optional) Database name appended to the URI. Default: "".
      hoop: # (Optional) Per-user Hoop.dev integration overrides.
        import: false # (Optional) When true, imports this user's existing Hoop connection. Default: false.
        access_control: [] # (Optional) Per-user access control merged with global hoop.access_control. Default: [].
  EOD
  type        = any
  default     = {}
}

variable "hoop" {
  description = <<-EOD
  hoop:
    enabled: false # (Optional) Enable Hoop.dev connection metadata output. Default: false.
    agent_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # (Required if enabled) Hoop.dev agent ID (UUID). No default.
    tags: # (Optional) Free-form tags for the Hoop connection. Default: {}.
      key: "value"
    access_control: [] # (Optional) Global access control list. Merged with per-user users[*].hoop.access_control. Default: [].
  EOD
  type        = any
  default     = {}
}

variable "rotation_lambda_name" {
  description = <<-EOD
  rotation_lambda_name: "" # (Optional) Name of the AWS Lambda used by Secrets Manager for credential rotation. When set, rotation is managed by Secrets Manager Lambda; when empty, passwords are rotated locally via time_rotating. Default: "".
  EOD
  type        = string
  default     = ""
  nullable    = false
}

variable "password_rotation_period" {
  description = <<-EOD
  password_rotation_period: 90 # (Optional) Default rotation period in days for all users. Overridden by users[*].password_rotation_period. Allowed: 1-365. Default: 90.
  EOD
  type        = number
  default     = 90
  nullable    = false
}

variable "rotation_duration" {
  description = <<-EOD
  rotation_duration: "1h" # (Optional) Max runtime for the rotation Lambda. Format: "1h", "2h30m". Default: "1h".
  EOD
  type        = string
  default     = "1h"
  nullable    = false
}

variable "rotate_immediately" {
  description = <<-EOD
  rotate_immediately: false # (Optional) When rotation is enabled, rotate immediately on enable/update. Default: false.
  EOD
  type        = bool
  default     = false
  nullable    = false
}

variable "force_reset" {
  description = <<-EOD
  force_reset: false # (Optional) Force-reset credentials even if unchanged (break-glass). Default: false.
  EOD
  type        = bool
  default     = false
}

variable "secrets_kms_key_id" {
  description = <<-EOD
  secrets_kms_key_id: "alias/aws/secretsmanager" # (Optional) KMS Key ID/ARN or Alias for AWS Secrets Manager encryption. Examples: "alias/aws/secretsmanager", "arn:aws:kms:us-east-1:123456789012:key/mrk-...". Default: null.
  EOD
  type        = string
  default     = null
}

variable "hoop_community" {
  description = <<-EOD
  hoop_community: true # (Optional) When true, use hoop community/open-source agent secret format (_aws:<secret>:<key>). When false, use enterprise/managed gateway format (_envs/aws/<secret>#<key>). Community only supports AWS Secrets Manager; GCP/Azure require manual agent configuration. Default: true.
  EOD
  type        = bool
  default     = true
  nullable    = false
}
