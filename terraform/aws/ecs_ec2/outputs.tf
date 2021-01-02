output "arn" {
    value = module.vpc.vpcArn
}

output "cidr_block" {
    value = module.vpc.vpcArn
}

output "id" {
    value = module.vpc.vpcId
}

output "publicsubnets" {
    value = module.vpc.publicSubnetIds
}

output "priavtesubnets" {
    value = module.vpc.privateSubnetIds
}

output "DBSubnetIds" {
    value = module.vpc.dBSubnetIds
}

output "internetGatewayId" {
    value = module.vpc.internetGatewayId
}

output "natGatewayId" {
    value = module.vpc.natGatewayId
}