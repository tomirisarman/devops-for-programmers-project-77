resource "yandex_mdb_postgresql_cluster" "db_cluster" {
  name        = "db-cluster"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.network-1.id

  config {
    version = 15

    resources {
      resource_preset_id = "c3-c2-m4"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }

    postgresql_config = {
      max_connections = 70
    }
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.subnet-1.id
  }
}

resource "yandex_mdb_postgresql_database" "db_cluster_db" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = var.db_name
  owner      = var.db_username
}

resource "yandex_mdb_postgresql_user" "db_cluster_user" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = var.db_username
  password   = var.db_password
}

resource "local_file" "ansible_db_vars" {
  content = templatefile("${path.module}/templates/db_vars.tmpl", {
    host     = yandex_mdb_postgresql_cluster.db_cluster.host[0].fqdn
    user     = var.db_username
    password = var.db_password
    db       = var.db_name
  })

  filename = "${path.module}/../ansible/group_vars/all/db_vars.yml"
}
