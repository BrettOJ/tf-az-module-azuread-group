#user variables

variable "user_display_name" {
  description = "The display name of the user."
  type = string
}

variable "password" {
  description = "The password of the user."
  type = string
}

variable "user_principal_name" {
  description = "The user principal name of the user."
  type = string
}

# group variables

variable "group_display_name" {
  description = "The display name of the group."
  type = string
}

variable "owners" {
    description = "The owners of the group."
    type = list(string)
}

variable "security_enabled" {
    description = "Whether the group is security enabled."
    type = bool
}

variable "group_members" {
    description = "The members of the group."
    type = list(string)
}
