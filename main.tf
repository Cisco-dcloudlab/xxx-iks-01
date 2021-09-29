provider "intersight" {
  apikey    = var.api_key
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {
  source = "terraform-cisco-modules/iks/intersight"
  version = "1.0.2"


  # Infra Config Policy Information
  cluster_name        = var.cluster_name
  cluster_action      = "False"
  vc_target_name      = var.vc_target_name
  vc_password         = var.vc_password
  vc_datastore        = var.datastore
  vc_cluster          = var.vc_cluster
  vc_resource_pool    = ""
  vc_portgroup        = [var.vc_portgroup]
  #vc_portgroup        = ["production|iks|nodes"]

  # IP Pool Information
  ip_starting_address = var.ip_starting_address
  ip_pool_size        = var.ip_pool_size
  #ip_starting_address = "100.64.0.200"
  #ip_pool_size        = "20"
  ip_netmask          = "255.255.255.0"
  #ip_gateway          = "100.64.0.1"
  ip_gateway          = var.ip_gateway
  ntp_servers         = ["198.19.255.137"]
  dns_servers         = ["198.19.254.82"]


  addons_list = [{
    addon_policy_name = "dashboard"
    addon             = "kubernetes-dashboard"
    description       = "K8s Dashboard Policy"
    upgrade_strategy  = "AlwaysReinstall"
    install_strategy  = "InstallOnly"
    },
    {
      addon_policy_name = "monitor"
      addon             = "ccp-monitor"
      description       = "Grafana Policy"
      upgrade_strategy  = "AlwaysReinstall"
      install_strategy  = "InstallOnly"
    }
  ]

  # Network Configuration Settings
  domain_name         = "dcv.svpod"
  timezone            = "Etc/GMT"

  # Network Configuration Settings
  pod_cidr = "100.64.8.0/22"
  service_cidr = "100.64.12.0/22"
  cni = "Calico"

  # Cluster information
  ssh_user            = "iksadmin"
  ssh_key             = var.ssh_key
  worker_size         = "small"
  worker_count        = 4
  master_count        = 1
  min_size            = 2
  load_balancers      = 3
  # Organization
  organization        = var.organization

}
