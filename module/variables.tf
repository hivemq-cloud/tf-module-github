variable "name" {
  description = "(Required) The name of the repository."
  type        = string
}

variable "description" {
  description = "(Optional) A description of the repository."
  type        = string
  default     = ""
}

variable "default_branch" {
  description = "(Optional) The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository. This means a user will have to omit this parameter from the initial repository creation and create the target branch inside of the repository prior to setting this attribute."
  type        = string
  default     = null
}

variable "branches" {
  description = "(Optional) A list of branches to be created in this repository."
  #   type        = any
  type = list(object({
    name = string
    # source_branch = optional(string)
    # source_sha    = optional(string)
  }))
  default = []
}

variable "template" {
  description = "(Optional) Template repository to use. (Default: {})"
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "archived" {
  description = "(Optional) Specifies if the repository should be archived. (Default: false)"
  type        = bool
  default     = false
}

variable "admin_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them admin (full) permission."
  type        = list(string)
  default     = []
}

variable "push_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them push (read-write) permission."
  type        = list(string)
  default     = []
}

variable "pull_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them pull (read-only) permission."
  type        = list(string)
  default     = []
}

variable "triage_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them triage permission."
  type        = list(string)
  default     = []
}

variable "maintain_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them maintain permission."
  type        = list(string)
  default     = []
}

variable "admin_team_ids" {
  description = "(Optional) A list of teams (by id) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

variable "push_team_ids" {
  description = "(Optional) A list of teams (by id) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "pull_team_ids" {
  description = "(Optional) A list of teams (by id) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "triage_team_ids" {
  description = "(Optional) A list of teams (by id) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "maintain_team_ids" {
  description = "(Optional) A list of teams (by id) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "admin_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

variable "push_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "pull_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "triage_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "maintain_teams" {
  description = "(Optional) A list of teams (by name/slug) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "archive_on_destroy" {
  type        = string
  description = "(Optional) Set to `false` to not archive the repository instead of deleting on destroy."
  default     = true
}

variable "auto_init" {
  description = "(Optional) Wether or not to produce an initial commit in the repository. (Default: true)"
  type        = bool
  default     = null
}