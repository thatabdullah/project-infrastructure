resource "alicloud_ecs_key_pair" "sshkey" {
  key_pair_name = "keypair"
  key_file      = "mycapstonekey2.pem"
}
