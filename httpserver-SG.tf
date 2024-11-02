resource "alicloud_security_group" "http-server" {
  name        = "http-server"
  description = "http-server SG"
  vpc_id      = alicloud_vpc.capstone-vpc.id
}

resource "alicloud_security_group_rule" "allow_bastion_to_ssh_to_http" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "22/22"
  priority                 = 1
  security_group_id        = alicloud_security_group.http-server.id
  source_security_group_id = alicloud_security_group.bastion-SG.id
}