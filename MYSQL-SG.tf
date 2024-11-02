resource "alicloud_security_group" "MYSQL-server" {
  name        = "MYSQL-server"
  description = "MYSQL-server SG"
  vpc_id      = alicloud_vpc.capstone-vpc.id
}

resource "alicloud_security_group_rule" "allow-http-to-access-MYSQL" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "3306/3306"
  priority                 = 1
  security_group_id        = alicloud_security_group.MYSQL-server.id
  source_security_group_id = alicloud_security_group.http-server.id
}
resource "alicloud_security_group_rule" "allow_bastion_to_mysql" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "22/22"
  priority                 = 1
  security_group_id        = alicloud_security_group.MYSQL-server.id
  source_security_group_id = alicloud_security_group.bastion-SG.id
}