module "network" {
  source           = "../common/network"
  environment_name = "prod"

  vpn_client_certificate_id = "08c3c543-176f-4833-9afc-3f9968603f45"
  vpn_server_certificate_id = "9e81565a-68b7-4aa5-8b14-28a2693e8ab0"
}

module "alb" {
  source           = "../common/alb"
  environment_name = "prod"

  depends_on = [
    module.network
  ]
}

module "ecs" {
  source           = "../common/ecs"
  environment_name = "prod"

  depends_on = [
    module.alb
  ]
}

module "rds" {
  source               = "../common/rds"
  environment_name     = "prod"

  service_name         = "backend"

  db_class             = "db.t3.medium"
  db_multi_az          = true
  db_allocated_storage = 20
}

module "redis" {
  source           = "../common/redis"
  environment_name = "prod"

  service_name     = "backend"
}

module "services" {
  source           = "../common/services"
  environment_name = "prod"

}
