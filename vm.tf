resource "google_compute_instance" "privare_vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  zone         = "asia-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }


  network_interface {
    network    = google_compute_network.vpc_gcp.id
    subnetwork = google_compute_subnetwork.management-subnet.id
  }

  service_account {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }
}
