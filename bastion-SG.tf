resource "alicloud_security_group" "bastion-SG" {
  name        = "bastion"
  description = "bastion security group"
  vpc_id      = alicloud_vpc.capstone-vpc.id
}


resource "alicloud_security_group_rule" "allow_bastion_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.bastion-SG.id
  cidr_ip           = "0.0.0.0/0"
}
