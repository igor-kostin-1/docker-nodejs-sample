
data "aws_acm_certificate" "certificate" {
  domain   = "igor-kostin.omega.devops.sitesstage.com"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name         = "omega.devops.sitesstage.com"
  private_zone = false
}

data "aws_lb" "app_alb"{
  arn  = "arn:aws:elasticloadbalancing:eu-central-1:162340708442:loadbalancer/app/k8s-vegaittr-app-74aae18182/f0968226683f8ba5"
  name = "k8s-vegaittr-app-74aae18182"
}

data "aws_lb_listener" "selected443" {
  load_balancer_arn = data.aws_lb.app_alb.arn
  port              = 443
}