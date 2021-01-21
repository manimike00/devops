variable "name" {}
variable "environment" {}
variable "container_port" {
  type = number
}
variable "vpc_id" {}
variable "cluster_id" {}
//variable "ecs_service_security_groups" {}
variable "subnets" {}
variable "container_image" {}