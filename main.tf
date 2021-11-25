provider "intersight" {
  apikey    = var.api_key
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {
  source = "terraform-cisco-modules/iks/intersight"
  version = "2.1.0"

  # Cluster information
  cluster = {
    name                = var.cluster_name
    action              = "False"
    action = "Deploy"
    wait_for_completion = false
    worker_nodes        = 4
    load_balancers      = 50
    worker_max          = 20
    control_nodes       = 1
    ssh_user            = "iksadmin"
    ssh_public_key      = var.ssh_key
  }

  # vCenter information
  infra_config_policy = {
    use_existing     = false
    name             = "iks-01-infra"
    vc_target_name   = var.vc_target_name
    vc_portgroups    = [var.vc_portgroup]
    vc_datastore     = var.datastore
    vc_cluster       = var.vc_cluster
    vc_resource_pool = ""
    vc_password      = var.vc_password
  }

  # Instance configuration
  instance_type = {
    use_existing = false
    name         = "iks-01-small"
    cpu          = 4
    memory       = 16384
    disk_size    = 40
  }

  # IP Pool information
  ip_pool = {
    use_existing        = false
    name                = "iks-01-ippool"
    ip_starting_address = var.ip_starting_address
    ip_pool_size        = var.ip_pool_size
    ip_netmask          = "255.255.255.0"
    ip_gateway          = var.ip_gateway
    dns_servers         = ["198.19.254.82"]
  }

  # System Configuration Settings
  sysconfig = {
    use_existing  = false
    name          = "iks-01-sysconfig"
    domain_name   = "dcv.svpod"
    timezone      = "Etc/GMT"
    ntp_servers   = ["198.19.255.137"]
    dns_servers   = ["198.19.254.82"]
  }

  # K8s internal networking configuration
  k8s_network = {
    use_existing = false
    name         = "iks-01-k8s-network"
    pod_cidr     = "172.30.0.0/16"
    service_cidr = "172.31.0.0/16"
    cni          = "Calico"
  }

  runtime_policy = {
    use_existing         = false
    create_new           = false
  }

  tr_policy = {
    use_existing         = false
    create_new           = false
  }

  version_policy = {
    use_existing = false
    name         = "1.19.5"
    version      = "1.19.5"
  }

  # Organization
  organization        = var.organization

  # Addons configuration
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
}
