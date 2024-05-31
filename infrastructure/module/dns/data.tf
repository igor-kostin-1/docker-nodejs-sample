data "aws_route53_zone" "zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

data "aws_lb" "app_alb"{
  tags = {
    "elbv2.k8s.aws/cluster" : "igork-cluster",
    "ingress.k8s.aws/resource" : "LoadBalancer",
    "ingress.k8s.aws/stack": "vegait-training/ecr-igork-private"
  }
}
