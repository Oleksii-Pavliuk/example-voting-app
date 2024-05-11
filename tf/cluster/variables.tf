variable "name"{
  description = "Cluster name"
  type = string
}
variable "region"{
  description = "region"
  type = string
}

variable "zone"{
  description = "zone"
  type = string
}

variable "network_id"{
  description = "network_id"
  type = string
}
variable "subnetwork_id"{
  description = "subnetwork"
  type = string
}
variable "subnetwork_secondary_ip_range"{
  description = "services_secondary_range_name"
  type = string
}