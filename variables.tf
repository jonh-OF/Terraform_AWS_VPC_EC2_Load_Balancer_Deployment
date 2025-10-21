variable "tipo_de_instancia" {
  type        = string
  description = "tipo de instancia"
  default     = "t3.micro"

}

variable "include_ipv4" {
  type    = bool
  default = true

}
variable "server_count" {
  type        = number
  description = "intaance count"
  default     = 3
}