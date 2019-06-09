resource "vsphere_virtual_machine" "vm-consul-master" {
  count            = "${var.launch_configuration_1["number_of_instace"]}"
  name             = "consulmaster-${count.index+1}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus                     = "${var.launch_configuration_1["number_of_cpu"]}"
  memory                       = "${var.launch_configuration_1["memory"]}"
  guest_id                     = "centos7_64Guest"
  wait_for_guest_net_timeout   = 0
  wait_for_guest_net_routable  = false

  disk {
    label            = "disk0"
    size             = "${var.launch_configuration_1["disk_size"]}"
    thin_provisioned = "true"
  }

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type   = "vmxnet3"
      }

  provisioner "file" {
    source      = "${var.launch_configuration_1.["public_key"]}"
    destination = "/home/centos/.ssh/authorized_keys"

    connection {
      type        = "${var.launch_configuration_1.["connection_type"]}"
      user        = "${var.launch_configuration_1.["connection_user"]}"
      password    = "${var.launch_configuration_1.["connection_password"]}"
    }
  provisioner "file" {
    source      = "install_docker.sh"
    destination = "/tmp/"

    connection {
      type        = "${var.launch_configuration_1.["connection_type"]}"
      user        = "${var.launch_configuration_1.["connection_user"]}"
      private_key = "${file("${var.launch_configuration_1.["private_key"]}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*sh",
      "sudo /tmp/install_docker.sh",
    ]
    connection {
      type          = "${var.launch_configuration_1.["connection_type"]}"
      user          = "${var.launch_configuration_1.["connection_user"]}"
      private_key   = "${file("${var.launch_configuration_1.["private_key"]}")}"
    }
  }
  # user_data = "${file("install_docker.sh")}"
} 
