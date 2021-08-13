variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
  default = {
    "Created by" = "QuyenNV"
    "Project" = "ILTestLAB"
    "Name" = "TL_LAB_TEST"
    "Evn" = "Dev"
  }
}
variable "prefix"{
    description = "The default prefix of name for project"
    type = string
    default = "IFTESTLAB"
}
variable "aws-linux2" {
    default = "ami-0b276ad63ba2d6009"
}
variable "instance-size" {
    default = "t2.small"
}
variable "currentIPACCESS"{
    default = "183.81.127.210/32"
}

variable "vpc_cidr"{
    default = "10.0.10.0/24"
}
variable "azonea"{
    default = "ap-northeast-1a"
}
variable "azonea_instance_cidr"{
    default = "10.0.10.32/27"
}

variable "azonea_db_cidr"{
    default = "10.0.10.128/28"
}

#for rds postgresql config
variable "identifier_db"{
    description = "The default init of db instance"
    type = string
    default = "il_db_init"
}

variable "db_name" {
  description = "The default name of db instance"
  type = string
  default = "ildb"
}
variable "engine_version" {
  description = "The default of engine"
  type = string
  default = "13.3"
}
variable "instance_class" {
  description = "The default type of rds instance"
  type = string
  default = "db.t3.micro"
}

variable "db_port" {
    description = "The default port of rds portgres"
    type = number
    default = 5432
}

variable "allocated_storage" {
    description = "The size of storage for db instane. unit Gb"
    type = number
    default = 20
}
variable "max_allocated_storage" {
    description = "The maximum size of storage for db instane. unit Gb"
    type = number
    default = 100
}
variable "storage_type" {
    description = "The type of disk of storage (SSD or megatic)"
    type =  string
    default = "gp2"
}

variable "availability_zone" {
    description = "The az for rds instace"
    type = string
    default = "ap-northeast-1a"
}

variable "publicly_accessible" {
  description = "Enable for public access or not"
  type = bool
  default = false
}