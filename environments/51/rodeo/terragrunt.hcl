# Include parent definitions
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../..//modules/rodeo"
}

inputs = {
  md_hosts = [
    { "name": "na1-pmd01", "availability_zone": "na2.ci01" },
    { "name": "na1-pmd10", "availability_zone": "na2.ci01" }
  ]

  image_name = "gdc-co7-7.7.10"
}
