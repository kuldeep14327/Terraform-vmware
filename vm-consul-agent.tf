resource "vsphere_virtual_machine" "vm-consul-agent" {
  count            = "${var.launch_configuration_2["number_of_instace"]}"
  name             = "consulagent-${count.index+1}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus                     = "${var.launch_configuration_2["number_of_cpu"]}"
  memory                       = "${var.launch_configuration_2["memory"]}"
  guest_id                     = "centos7_64Guest"
  wait_for_guest_net_timeout   = 0
  wait_for_guest_net_routable  = false

  disk {
    label            = "disk0"
    size             = "${var.launch_configuration_2["disk_size"]}"
    thin_provisioned = "true"
  }

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type   = "vmxnet3"
  }
  provisioner "file" {
    source      = "${var.launch_configuration_2.["public_key"]}"
    destination = "/home/centos/.ssh/authorized_keys"

    connection {
      type        = "${var.launch_configuration_2.["connection_type"]}"
      user        = "${var.launch_configuration_2.["connection_user"]}"
      password    = "${var.launch_configuration_2.["connection_password"]}"
    }
  }
  provisioner "file" {
    source      = "install_docker.sh"
    destination = "/tmp/"

    connection {
      type        = "${var.launch_configuration_2.["connection_type"]}"
      user        = "${var.launch_configuration_2.["connection_user"]}"
      private_key = "${file("${var.launch_configuration_2.["private_key"]}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*sh",
      "sudo /tmp/install_docker.sh",
    ]
    connection {
      type          = "${var.launch_configuration_2.["connection_type"]}"
      user          = "${var.launch_configuration_2.["connection_user"]}"
      private_key   = "${file("${var.launch_configuration_2.["private_key"]}")}"
    }
  }
}