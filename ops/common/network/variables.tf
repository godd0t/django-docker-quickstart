variable environment_name {
  description = "The name of the environment that you are about to create."
  type        = string
  default     = "dev"
}

variable vpn_server_certificate_id {
  description = "The certificate ID to be used on the VPN Client Endpoint."
  type        = string
}

variable vpn_client_certificate_id {
  description = "The certificate ID to be used by clients connecting through the VPN Client Endpoint."
  type        = string
}
