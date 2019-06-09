data "vsphere_datacenter" "datacenter" {
  name = "${var.datacenter_name}"
}