#key pair
resource "aws_key_pair" "kp_instance" {
  key_name = "ec2-app"
  public_key = var.aws_key_pair_public
}
#create the security group for ec2 instance
resource "aws_security_group" "sg_ec2_instance" {
    vpc_id = var.vpc_id
    name = "SG EC2 APP INSTANCE"
    description = "Facing the internet application"
    ingress =[{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.allow_IP]
        ipv6_cidr_blocks = null
        prefix_list_ids = null
        security_groups = null
        self = null
    },
    {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [var.cidr_allow]
        ipv6_cidr_blocks = null
        prefix_list_ids = null
        security_groups = null
        self = null
        description = "Expose the jenkins server"
    },
    {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = [var.cird_allow]
        ipv6_cidr_blocks = null
        prefix_list_ids = null
        security_groups = null
        self = null
        description = "expose the api server"
    }]
    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = var.tags
}
#create the instance
resource "aws_instance" "ec2_instance" {
  ami = var.instanceami
  instance_type = var.instancesize
  vpc_security_group_ids = [ aws_security_group.sg_ec2_instance.id ]
  subnet_id = var.sn_instance_id
  tags = merge(var.tags,{Name = "EC2 Instance App"})
  key_name = aws_key_pair.kp_instance.key_name

}
#request EIP
resource "aws_eip" "eip_ec2_instance" {
  instance = aws_instance.ec2_instance.id
  vpc = true
  tags = var.tags
}