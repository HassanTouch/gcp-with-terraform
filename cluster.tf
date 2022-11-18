resource "google_container_cluster" "k8-cluster" {
  project  = "project-for-gcp-368920"
  name     = "k8-cluster"
  location = "asia-east1"

  network    = google_compute_network.vpc_gcp.id
  subnetwork = google_compute_subnetwork.restricted-subnet.id

  #min_master_version = "1.16"

  # Enable Alias IPs to allow Windows Server networking.

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.3.0.0/16"
    services_ipv4_cidr_block = "10.4.0.0/16"
  }



  remove_default_node_pool = true
  initial_node_count       = 1



  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/16"
      display_name = "management"
    }
  }

  ##to make master in private network 
  private_cluster_config {
    master_ipv4_cidr_block  = "172.16.0.0/28"
    enable_private_nodes    = true
    enable_private_endpoint = true
  }
}





resource "google_container_node_pool" "nodes" {
  name       = "node-01"
  project    = google_container_cluster.k8-cluster.project
  cluster    = google_container_cluster.k8-cluster.name
  location   = google_container_cluster.k8-cluster.location
  node_count = 1


}


resource "google_service_account" "sa" {
  project      = "project-for-gcp-368920"
  account_id   = "service-account-id"
  display_name = "service-account-id"
}

resource "google_project_iam_binding" "role_1" {
  project = "project-for-gcp-368920"
  role    = "roles/storage.admin"
  members = [

    "serviceAccount:service-account-id@project-for-gcp-368920.iam.gserviceaccount.com",
  ]

  depends_on = [google_service_account.sa]
}



resource "google_project_iam_binding" "role_2" {
  project = "project-for-gcp-368920"
  role    = "roles/container.admin"
  members = [
    "serviceAccount:service-account-id@project-for-gcp-368920.iam.gserviceaccount.com",

  ]
  depends_on = [google_service_account.sa]
}


#roles/storage.admin
####allow IAP 
resource "google_compute_firewall" "allow_iap" {
  name    = "allow-iap"
  network = google_compute_network.vpc_gcp.id

  allow {
    protocol = "tcp"
    ports    = ["22","80","443"]
  }
  source_ranges = ["35.235.240.0/20"]

}