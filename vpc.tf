data "alicloud_zones" "availability_zones" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "capstone-vpc" {
    cidr_block = "10.0.0.0/8"
    vpc_name = "capstone-vpc"
  
}
resource "alicloud_vswitch" "public-switch" {
  cidr_block = "10.0.1.0/24"
  vpc_id = alicloud_vpc.capstone-vpc.id
  vswitch_name = "public-switch"
  zone_id = data.alicloud_zones.availability_zones.zones.0.id
}
resource "alicloud_vswitch" "private-switch" {
  cidr_block = "10.0.2.0/24"
  vswitch_name = "private-switch"
  vpc_id = alicloud_vpc.capstone-vpc.id
  zone_id = data.alicloud_zones.availability_zones.zones.0.id
}
resource "alicloud_vswitch" "second-public-switch" {
  cidr_block = "10.0.3.0/24"
  vpc_id = alicloud_vpc.capstone-vpc.id
  vswitch_name = "2nd-public-switch"
  zone_id = data.alicloud_zones.availability_zones.zones.1.id
}
resource "alicloud_route_table" "private-route" {
  vpc_id = alicloud_vpc.capstone-vpc.id
  route_table_name = "private-route"
  associate_type = "VSwitch"
}
resource "alicloud_route_table_attachment" "private-route-attachment" {
  vswitch_id = alicloud_vswitch.private-switch.id
  route_table_id = alicloud_route_table.private-route.id
}
resource "alicloud_nat_gateway" "capstone-NAT-gateway" {
  vpc_id = alicloud_vpc.capstone-vpc.id
  nat_gateway_name = "capstone-nat"
  payment_type = "PayAsYouGo"
  vswitch_id = alicloud_vswitch.public-switch.id
  nat_type = "Enhanced"
}

resource "alicloud_eip_address" "NAT-eIP" {
  description = "nat's elastic IP"
  address_name = "NAT"
  netmode = "public"
  bandwidth = "100"
  payment_type = "PayAsYouGo"
  internet_charge_type = "PayByTraffic"
}
resource "alicloud_eip_association" "eIP-association" {
  instance_type = "Nat"  
  instance_id = alicloud_nat_gateway.capstone-NAT-gateway.id
  allocation_id = alicloud_eip_address.NAT-eIP.id
}
resource "alicloud_snat_entry" "Snat-entry" {
  snat_ip = alicloud_eip_address.NAT-eIP.ip_address
  snat_table_id = alicloud_nat_gateway.capstone-NAT-gateway.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private-switch.id
}
resource "alicloud_route_entry" "private-route-entry" {
  route_table_id = alicloud_route_table.private-route.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type = "NatGateway"
  nexthop_id = alicloud_nat_gateway.capstone-NAT-gateway.id
}