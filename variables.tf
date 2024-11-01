variable "display_name" {
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

