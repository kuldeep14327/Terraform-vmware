data "vsphere_compute_cluster" "cluster" {
  name          = "${var.compute_cluster_name}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}