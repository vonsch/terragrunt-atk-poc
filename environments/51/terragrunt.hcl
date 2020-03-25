# Cluster-wide common configuration

remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks-51"
    bucket         = "ord1-na1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

contents = <<EOF
  provider "openstack" {
    user_name   = "kitchen"
    tenant_name = "NA2.Test"
    auth_url    = "https://cloud-api.na2.intgdc.com:5000/v2.0"
  }
EOF
}

inputs = {
  user_data = "${get_parent_terragrunt_dir()}/../../scripts/userdata.sh.tmpl"
}
