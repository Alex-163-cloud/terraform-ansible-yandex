terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1gfcfuh0ka1q93nq819"
  folder_id = "b1g3jq7jeg7qd0auf0q0"
  zone      = "ru-central1-a"
}

# 1. Берем самый свежий образ Ubuntu 22.04 из Yandex Cloud
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# 2. Создаем виртуальную машину
resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = "standard-v3"
  zone        = var.vm_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  network_interface {
    subnet_id = "e9bh5pe55ltmr0kmhck1" # СЮДА ВСТАВИМ ID ПОДСЕТИ
    nat       = true     # Публичный IP для доступа
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# 3. Выводим публичный IP
output "vm_ip" {
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

# 4. Генерируем inventory.ini для Ansible
resource "local_file" "ansible_inventory" {
  content  = <<-EOT
[webservers]
terraform-vm ansible_host=${yandex_compute_instance.vm.network_interface.0.nat_ip_address} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
EOT
  filename = "${path.module}/inventory.ini"
}
