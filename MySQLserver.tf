resource "alicloud_instance" "MYSQL-server" {
  availability_zone = data.alicloud_zones.availability_zones.zones.0.id
  security_groups   = [alicloud_security_group.MYSQL-server.id]
  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  system_disk_size           = 40
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "MYSQL-server"
  vswitch_id                 = alicloud_vswitch.private-switch.id
  internet_max_bandwidth_out = 0
  instance_charge_type       = "PostPaid"
  key_name                   = alicloud_ecs_key_pair.sshkey.key_pair_name

  user_data = base64encode(file("MYSQL-setup.sh"))
}

output "MYSQL_private_ips" {
  value = alicloud_instance.MYSQL-server.*.private_ip
}
