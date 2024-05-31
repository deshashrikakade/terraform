variable "environment" {
  type        = string
  default     = "production"
}
 
variable "add_volume" {
  type        = bool
  default     = false
}
 
variable "include_security_group" {
  type        = bool
  default     = false
}
 
resource "aws_instance" "ec2_instance" {
  ami           = "ami-00beae93a2d981137" 
  instance_type = var.environment == "production" ? "m3.large" : "t2.micro"
  tags = {
    "Name" = "MyEC2Instance"
    var.environment == "production" ? "Critical" : "Testing" = "true"
  }
}
 
resource "aws_ebs_volume" "additional_volume" {
  count             = var.add_volume ? 1 : 0
  availability_zone = aws_instance.ec2_instance.availability_zone
  size              = 10
  tags = {
    "Name" = "AdditionalVolume"
  }
}
 
resource "aws_security_group" "custom_security_group" {
  count = var.include_security_group ? 1 : 0
  name        = "CustomSecurityGroup"
}
 
resource "aws_instance" "ec2_instance_with_sg" {
  count         = var.include_security_group ? 1 : 0
  ami           = "ami-00beae93a2d981137" 
  instance_type = var.environment == "production" ? "m3.large" : "t2.micro"
  security_groups = aws_security_group.custom_security_group[count.index]
  tags = {
    "Name" = "MyEC2InstanceWithSG"
    var.environment == "production" ? "Critical" : "Testing" = "true"
  }
}
 
 
