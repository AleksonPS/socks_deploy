data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "vm-manager" {
  count    = var.managers
  name     = "ci-sockshop-docker-swarm-manager-${count.index}"
  hostname = "manager-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    user-data = "${file("/home/alps/socks_deploy/ya_cloud_user_metadata.yml")}"
  }

}
resource "yandex_compute_instance" "vm-worker" {
  count    = var.workers
  name     = "ci-sockshop-docker-swarm-worker-${count.index}"
  hostname = "worker-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    user-data = "${file("/home/alps/socks_deploy/ya_cloud_user_metadata.yml")}"
  }

}