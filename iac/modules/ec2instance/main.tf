#create the security group for ec2 instance
resource "aws_security_group" "sg_ec2_instance" {
    vpc_id = var.vpc_id
    name = "SG EC2 APP INSTANCE"
    description = "Facing the internet application"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
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
  tags = var.tags
}
#request EIP
resource "aws_eip" "eip_ec2_instance" {
  instance = aws_instance.ec2_instance.id
  vpc = true
  tags = var.tags
}