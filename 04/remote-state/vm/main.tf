data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    ssh_key = var.public_key
  }
}

# ВМ создаётся в сети/подсети из соседнего root-модуля vpc (через remote state).
module "vm" {
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"

  env_name       = "remote-state"
  network_id     = data.terraform_remote_state.vpc.outputs.network_id
  subnet_zones   = data.terraform_remote_state.vpc.outputs.subnet_zones
  subnet_ids     = values(data.terraform_remote_state.vpc.outputs.subnet_ids)
  instance_name  = "vm"
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true
  preemptible    = true

  labels = {
    project = "remote-state-demo"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = "1"
  }
}
