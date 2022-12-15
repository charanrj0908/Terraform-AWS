variable "region" {
     default = "us-west-2"
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "tagname" {
  default = "demo"
}
variable "availabilityZone" {
     default = "us-west-2a"
}
variable "subnetCIDRblock" {
    default = "10.0.1.0/24"
}
variable "mapPublicIP" {
    default = true
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"

}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "ami_id" {
    default = "ami-008c6427c8facbe08"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_key_pair_name" {
    default = "charankey"
}
