output "instance_ips" {
  value = [
    for instance in yandex_compute_instance_group.ig-1.instances :
    instance.network_interface[0].nat_ip_address
  ]
  depends_on = [yandex_compute_instance_group.ig-1]
}
