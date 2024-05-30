
data "aws_acm_certificate" "certificate" {
  domain   = "igor-kostin.omega.devops.sitesstage.com"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name         = "omega.devops.sitesstage.com"
  private_zone = false
}

data "aws_lb" "app_alb"{
  arn  = "arn:aws:elasticloadbalancing:eu-central-1:162340708442:loadbalancer/app/k8s-vegaittr-app-74aae18182/8920f6d3d2b0d671"
  name = "k8s-vegaittr-app-74aae18182"
}
