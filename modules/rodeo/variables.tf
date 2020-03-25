variable "md_hosts" {
  description = "List of running metatada hosts"
  type        = list(map(string))
}

variable "image_name" {
  description = "Base image for deploys"
  type        = string
}

variable "user_data" {
  description = "Userdata template path"
  type        = string
}
