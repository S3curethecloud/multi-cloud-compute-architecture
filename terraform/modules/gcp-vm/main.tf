resource "google_compute_address" "static_ip" {
  name   = "${var.vm_name}-ip"
  region = var.region
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
  initialize_params {
    image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
  }
}

  network_interface {
    network    = var.network
    subnetwork = var.subnet

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
    startup-script = <<EOF
#!/bin/bash
apt update -y
EOF
  }
}
