variable "candidate" {
  default = "andy"
}
variable "vpc_cidr" {
  default = "10.150.0.0/20"
}
variable "number_of_azs" {
  default = 3
}
// Additional Settings
variable "AWS_REGION" {
  default = "eu-west-1"
}
variable "AMIS" {
  type = map(string)
  default = { # Amazon Linux 2
    us-east-1 = "ami-02e136e904f3da870"
    eu-west-1 = "ami-05cd35b907b4ffe77"
    eu-west-2 = "ami-02f5781cba46a5e8a"
  }
}
# Free Tier Eligible 
variable "instance_type" {
  # default = "t2.micro"
  default = "t3.nano"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/mykey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/mykey.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

