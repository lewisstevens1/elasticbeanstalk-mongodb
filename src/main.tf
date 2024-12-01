module "networking" {
  source = "./modules/networking"

  environment     = var.environment
  resource_prefix = var.resource_prefix
}

module "database" {
  source = "./modules/mongo-database"

  environment     = var.environment
  resource_prefix = var.resource_prefix

  vpc_id                = module.networking.vpc_id
  private_subnets       = module.networking.private_subnets
  r53_zone_id           = module.networking.r53_zone_id
  public_route_table_id = module.networking.public_route_table_id
}

module "elastic_beanstalk" {
  source = "./modules/elastic-beanstalk"

  environment     = var.environment
  resource_prefix = var.resource_prefix

  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
}
