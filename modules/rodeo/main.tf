# RODEO machines

terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_secgroup_v2" "md" {
  name            = "md"
  description     = "Metadata security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}


resource "openstack_compute_instance_v2" "md_hosts" {
  count             = length(var.md_hosts)
  name              = var.md_hosts[count.index]["name"]

  flavor_name       = "sh1-c2r15e450"
  image_name        = var.image_name
  availability_zone = var.md_hosts[count.index]["availability_zone"]

  security_groups   = ["md"]

  user_data         = templatefile(var.user_data, {})

  lifecycle {
    ignore_changes = [
      availability_zone
    ]
  }
}

# Attach floating IP
resource "openstack_compute_floatingip_v2" "floating_ip" {
  count = length(var.md_hosts)
  pool  = "floating"
}

resource "openstack_compute_floatingip_associate_v2" "associate" {
  count       = length(var.md_hosts)
  floating_ip = openstack_compute_floatingip_v2.floating_ip[count.index]["address"]
  instance_id = openstack_compute_instance_v2.md_hosts[count.index]["id"]
}

# Add EBS
resource "openstack_blockstorage_volume_v2" "md_volume" {
  count             = length(var.md_hosts)
  name              = var.md_hosts[count.index]["name"]
  size              = 1
  availability_zone = "na2.netapp02"
}
resource "openstack_compute_volume_attach_v2" "md_volume_attach" {
  count       = length(var.md_hosts)
  volume_id   = openstack_blockstorage_volume_v2.md_volume[count.index]["id"]
  instance_id = openstack_compute_instance_v2.md_hosts[count.index]["id"]
}


