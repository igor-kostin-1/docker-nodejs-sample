resource "kubernetes_storage_class" "psql_sc" {
  metadata {
    name = "ebssc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type = "gp3"
  }
}