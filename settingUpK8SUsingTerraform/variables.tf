variable "region" {
    type =  string
    description = "region for the network"
}
variable "gcp_project_id" {
    type = string
}
variable "credentials" {
    description = " will contain the .JSON file for connecting to the Google Cloud API "
}

variable "env_name"{
    type = string
    description = "will contains the enviornment variable required to create resources"
}
variable "cidr_range" {
   type        = string
   description = "cidr ranges for subnet creation"
}
variable "nodecount"{
    type = number 
    description = "will count number of nodes"
}
variable "machine" {
    type = string
    description = "machine name for nodes"
}
variable "ports"{
    type = number
}
variable "targetport"{
    type = number
    description = "contains target port"
}
variable "imagename" {
    type = string
    description = "this is the image hosted for the pods"
}

variable "containerport"{
    type = number
    description = "contains the port of the container"
}

