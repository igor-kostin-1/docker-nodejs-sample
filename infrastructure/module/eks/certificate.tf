module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = "igor-kostin.omega.devops.sitesstage.com"
  zone_id      = "Z07475403IQFN5IUZ6XJ9"

  validation_method = "DNS"

  wait_for_validation = false

  tags = {
    Name = "igor-kostin.omega.devops.sitesstage.com",
    Owner = "Igor Kostin"
  }
}
