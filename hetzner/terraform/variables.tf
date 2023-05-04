variable "hcloud_token" {
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "location" {
  default = "nbg1"
}

variable "http_protocol" {
  default = "http"
}

variable "http_port" {
  default = "80"
}

variable "instances" {
  default = "2"
}

variable "server_type" {
  default = "cx31"
}

variable "os_type" {
  default = "ubuntu-22.04"
}

variable "ip_range" {
  default = "10.0.0.0/24"
}
