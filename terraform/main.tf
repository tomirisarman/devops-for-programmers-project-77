terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "kz1-a"
  endpoint = "api.yandexcloud.kz:443"
  token = var.yc_token
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "Сервисный аккаунт для управления группой ВМ."
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
}

resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig-with-balancer-1"
  service_account_id  = "${yandex_iam_service_account.ig-sa.id}"
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }
    scheduling_policy {
      preemptible = true
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.image_id
      }
    }

    network_interface {
      network_id         = "${yandex_vpc_network.network-1.id}"
      subnet_ids         = ["${yandex_vpc_subnet.subnet-1.id}"]
      security_group_ids = ["${yandex_vpc_security_group.sg-1.id}"]
      nat = true
    }

    metadata = {
      serial-port-enable = 1
      ssh-keys = "admin:${file(var.ssh_public_key)}"
      user-data =  <<EOF
#cloud-config
datasource:
 Ec2:
  strict_id: false
ssh_pwauth: no
users:
 - name: admin
  groups: sudo
  shell: /bin/bash
  sudo: ['ALL=(ALL) NOPASSWD:ALL']
  ssh-authorized-keys:
   - ${file("${var.ssh_public_key}")}
EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["kz1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  application_load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }

  health_check {
    tcp_options {
      port = 22
    }
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "kz1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_security_group" "sg-1" {
  name        = "Test security group"
  description = "Description for security group"
  network_id  = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow SSH"
  }

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/16"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/16"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/16"]
    port           = 30080
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_alb_http_router" "alb-router" {
  name = "my-http-router"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = "s"
  }
}

resource "yandex_alb_load_balancer" "my_alb" {
  name = "my-load-balancer"

  network_id = yandex_vpc_network.network-1.id

  allocation_policy {
    location {
      zone_id   = "kz1-a"
      subnet_id = yandex_vpc_subnet.subnet-1.id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [8080]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb-router.id
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent     = 75
    }
  }
}