variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "terraform-vm"
}

variable "vm_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}
