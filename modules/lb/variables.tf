variable "name" {}

variable "backends" {
  type    = list(string)
  default = []
}

variable "lb_name" {}                  # must match root/main.tf argument
#variable "neg" {}                      # must match root/main.tf argument
variable "health_check_port" {}        # was previously "health_checks_port" → fix name
variable "health_check_path" {}
variable "region" {}
# variable "neg" {
#   type = map(string)  
# }