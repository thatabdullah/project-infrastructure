resource "alicloud_instance" "http-server" {
  count             = 2
  availability_zone = data.alicloud_zones.availability_zones.zones.0.id
  security_groups   = [alicloud_security_group.http-server.id]
  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  system_disk_size           = 40
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "http-server-${count.index}"
  vswitch_id                 = alicloud_vswitch.private-switch.id
  internet_max_bandwidth_out = 0
  instance_charge_type       = "PostPaid"
  key_name                   = alicloud_ecs_key_pair.sshkey.key_pair_name

  user_data = base64encode(templatefile("http-setup.tpl", { redis_host = alicloud_instance.redis.private_ip, db_host= alicloud_instance.MYSQL-server.private_ip}))
}

output "http_server_private_ips" {
  value = alicloud_instance.http-server.*.private_ip
}
