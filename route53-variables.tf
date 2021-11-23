# AWS Route 53 Variables
variable "route53_mydomain" {
  description = "Domain Name"
  type = string 
  default = "domain.com"
}

variable "route53_route53_apps_default_dns" {
  description = "Default DNS Name"
  type = string 
  default = "myapps.domain.com"
}

variable "route53_app1_dns_name" {
  description = "App1 DNS Name"
  type = string
  default = "app1.domain.com"
}

variable "route53_app2_dns_name" {
  description = "App2 DNS Name"
  type = string
  default = "app2.domain.com"
}

