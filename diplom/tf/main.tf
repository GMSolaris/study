resource "yandex_compute_instance" "main_server" {
  name     = "main"
  hostname = "weltonauto.com"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd82re2tpfl4chaupeuf"
      size     = 6
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet-1.id
    nat            = true
    nat_ip_address = var.reserved_ip
  }

  metadata = {
    user-data = "${file("meta.txt")}"
#    ssh-keys  = "ubuntu:${file("id_rsa.pub")}"
  }
}