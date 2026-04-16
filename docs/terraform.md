## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.35 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~> 2.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mongoatlas_users"></a> [mongoatlas\_users](#module\_mongoatlas\_users) | git::https://github.com/cloudopsworks/terraform-module-mongoatlas-users.git | v1.4.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.atlas_cred_conn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.atlas_cred_conn_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.atlas_cred_conn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.atlas_cred_conn_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_lambda_function.rotation_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_function) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret_version.atlas_cred_conn_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_versions.atlas_cred_conn_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_versions) | data source |
| [aws_secretsmanager_secrets.atlas_cred_conn_rotated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secrets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_force_reset"></a> [force\_reset](#input\_force\_reset) | force\_reset: false # (Optional) Force-reset credentials even if unchanged (break-glass). Default: false. | `bool` | `false` | no |
| <a name="input_hoop"></a> [hoop](#input\_hoop) | hoop:<br/>  enabled: false # (Optional) Enable Hoop.dev connection metadata output. Default: false.<br/>  community: true # (Optional) When true, use community/open-source agent secret format (\_aws:<secret>:<key>). When false, use enterprise/managed gateway format (\_envs/aws/<secret>#<key>). Default: true.<br/>  agent\_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # (Required if enabled) Hoop.dev agent ID (UUID). No default.<br/>  tags: # (Optional) Free-form tags for the Hoop connection. Default: {}.<br/>    key: "value"<br/>  access\_control: [] # (Optional) Global access control list. Merged with per-user users[*].hoop.access\_control. Default: []. | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | name\_prefix: "atlas" # (Required) Prefix used to compose usernames when `users[<key>].username` is not provided. Allowed: lowercase letters, numbers, and hyphens. No default. | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_password_rotation_period"></a> [password\_rotation\_period](#input\_password\_rotation\_period) | password\_rotation\_period: 90 # (Optional) Default rotation period in days for all users. Overridden by users[*].password\_rotation\_period. Allowed: 1-365. Default: 90. | `number` | `90` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project\_id: "60f0f0f0f0f0f0f0f0f0f0f0" # (Optional) Atlas Project ID. One of `project_id` or `project_name` must be provided. Default: "". | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project\_name: "my-project" # (Optional) Atlas Project Name. One of `project_id` or `project_name` must be provided. Default: "". | `string` | `""` | no |
| <a name="input_rotate_immediately"></a> [rotate\_immediately](#input\_rotate\_immediately) | rotate\_immediately: false # (Optional) When rotation is enabled, rotate immediately on enable/update. Default: false. | `bool` | `false` | no |
| <a name="input_rotation_duration"></a> [rotation\_duration](#input\_rotation\_duration) | rotation\_duration: "1h" # (Optional) Max runtime for the rotation Lambda. Format: "1h", "2h30m". Default: "1h". | `string` | `"1h"` | no |
| <a name="input_rotation_lambda_name"></a> [rotation\_lambda\_name](#input\_rotation\_lambda\_name) | rotation\_lambda\_name: "" # (Optional) Name of the AWS Lambda used by Secrets Manager for credential rotation. When set, rotation is managed by Secrets Manager Lambda; when empty, passwords are rotated locally via time\_rotating. Default: "". | `string` | `""` | no |
| <a name="input_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#input\_secrets\_kms\_key\_id) | secrets\_kms\_key\_id: "alias/aws/secretsmanager" # (Optional) KMS Key ID/ARN or Alias for AWS Secrets Manager encryption. Examples: "alias/aws/secretsmanager", "arn:aws:kms:us-east-1:123456789012:key/mrk-...". Default: null. | `string` | `null` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_users"></a> [users](#input\_users) | users:<br/>  <user\_key>:<br/>    username: "user1" # (Optional) Explicit username. If omitted, composed as `<name_prefix|user.name_prefix>-<system_name_short>-<user_key>`. Default: generated.<br/>    name\_prefix: "prefix1" # (Optional) Per-user prefix to build the username. If omitted, uses var.name\_prefix. Default: null.<br/>    auth\_database: "admin" # (Optional) Authentication database. Common: "admin". Default: "admin".<br/>    password\_rotation\_period: 90 # (Optional) Rotation period in days for this user. Overrides var.password\_rotation\_period. Default: var.password\_rotation\_period.<br/>    import: false # (Optional) When true, imports an existing MongoDB Atlas user instead of creating a new one. Default: false.<br/>    role\_name: "readwrite" # (Optional) Top-level primary role key used for Hoop connection naming. Allowed: readwrite, read, dbadmin, admin, dbowner, owner, clusteradmin. Default: "default".<br/>    roles: # (Required) MongoDB roles granted to this user.<br/>      - role\_name: "readWrite" # (Required) Built-in or custom role name. Common: read, readWrite, dbAdmin, dbOwner, userAdmin, clusterAdmin. No default.<br/>        database\_name: "test" # (Required) Database that the role applies to. No default.<br/>        collection\_name: "widgets" # (Optional) Collection the role is scoped to. Default: null.<br/>    scopes: # (Optional) Atlas scope bindings for the user.<br/>      - name: "cluster-name" # (Required) Target cluster or data lake name. No default.<br/>        type: "CLUSTER" # (Optional) Scope type. Allowed: CLUSTER, DATA\_LAKE. Default: "CLUSTER".<br/>    connection\_strings: # (Optional) Control generation of connection strings in Secrets Manager.<br/>      enabled: false # (Optional) When true, store connection strings. Default: false.<br/>      cluster: "cluster0" # (Required if enabled) Atlas Cluster name. No default.<br/>      endpoint\_id: "vpce-0123456789abcdef" # (Optional) Private endpoint ID for PrivateLink strings. Default: "".<br/>      database\_name: "mydatabase" # (Optional) Database name appended to the URI. Default: "".<br/>    hoop: # (Optional) Per-user Hoop.dev integration overrides.<br/>      import: false # (Optional) When true, imports this user's existing Hoop connection. Default: false.<br/>      access\_control: [] # (Optional) Per-user access control merged with global hoop.access\_control. Default: []. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hoop_connections"></a> [hoop\_connections](#output\_hoop\_connections) | Hoop connection definitions enriched with AWS Secrets Manager secret references. Pass as the `connections` input to terraform-module-hoop-connection. Community mode uses \_aws:<secret>:<key> syntax; enterprise mode uses \_envs/aws/<secret-name>#<key>. |
| <a name="output_users"></a> [users](#output\_users) | User metadata map enriched with the AWS Secrets Manager secret name for each user's credentials. |
