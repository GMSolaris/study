resource "yandex_compute_instance" "app" {
  name     = "app"
  hostname = "app.weltonauto.com"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd82re2tpfl4chaupeuf"
      size     = 6
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
  }

  metadata = {
    user-data = "${file("meta.txt")}"
#    ssh-keys  = "sovar:${file("pub")}"
  }
}