locals {
  mappings = {
    SubnetConfig = {
      Internet = {
        CIDR = "0.0.0.0/0"
      }
      VPC = {
        CIDR = "10.0.0.0/16"
      }
      VPCDnsServer = {
        IP = "10.0.0.2"
      }
      Client = {
        CIDR = "192.168.0.0/22"
      }
      PublicOne = {
        CIDR = "10.0.0.0/20"
      }
      PublicTwo = {
        CIDR = "10.0.16.0/20"
      }
      PrivateOne = {
        CIDR = "10.0.32.0/20"
      }
      PrivateTwo = {
        CIDR = "10.0.48.0/20"
      }
    }
  }
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}