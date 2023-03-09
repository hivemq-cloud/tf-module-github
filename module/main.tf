terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  token = "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"
  owner = "hivemq-cloud"
}

locals {

  visibility             = "private"
  has_issues             = true
  has_discussions        = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  auto_init              = true
  default_branch         = var.default_branch
  template               = var.template == null ? [] : [var.template]
  vulnerability_alerts   = true
}


# ---------------------------------------------------------------------------------------------------------------------
# Create the repository
# ---------------------------------------------------------------------------------------------------------------------

resource "github_repository" "repository" {
  name                   = var.name
  description            = var.description
  visibility             = local.visibility
  has_issues             = local.has_issues
  has_discussions        = local.has_discussions
  allow_merge_commit     = local.allow_merge_commit
  delete_branch_on_merge = local.delete_branch_on_merge
  auto_init              = local.auto_init
  vulnerability_alerts   = local.vulnerability_alerts
  archived               = var.archived

  archive_on_destroy = var.archive_on_destroy

  dynamic "template" {
    for_each = local.template

    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Manage branches
# ---------------------------------------------------------------------------------------------------------------------

locals {
  branches_map = { for b in var.branches : b.name => b }
}

resource "github_branch" "branch" {
  for_each = local.branches_map

  repository    = github_repository.repository.name
  branch        = each.key
  source_branch = try(each.value.source_branch, null)
  source_sha    = try(each.value.source_sha, null)
}

# ---------------------------------------------------------------------------------------------------------------------
# Set default branch
# ---------------------------------------------------------------------------------------------------------------------

resource "github_branch_default" "default" {
  count = local.default_branch != null ? 1 : 0

  repository = github_repository.repository.name
  branch     = local.default_branch

  depends_on = [github_branch.branch]
}


# ---------------------------------------------------------------------------------------------------------------------
# Branch Protection
# ---------------------------------------------------------------------------------------------------------------------

resource "github_branch_protection_v3" "main" {
  repository             = github_repository.repository.name
  branch                 = "main"
  enforce_admins         = true
  require_signed_commits = true

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
  }
}

resource "github_branch_protection" "wildcard" {
  repository_id          = github_repository.repository.id
  pattern                = "*"
  enforce_admins         = true
  require_signed_commits = true
  allows_deletions       = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Collaborators
# ---------------------------------------------------------------------------------------------------------------------

locals {
  collab_admin    = { for i in var.admin_collaborators : i => "admin" }
  collab_push     = { for i in var.push_collaborators : i => "push" }
  collab_pull     = { for i in var.pull_collaborators : i => "pull" }
  collab_triage   = { for i in var.triage_collaborators : i => "triage" }
  collab_maintain = { for i in var.maintain_collaborators : i => "maintain" }

  collaborators = merge(
    local.collab_admin,
    local.collab_push,
    local.collab_pull,
    local.collab_triage,
    local.collab_maintain,
  )
}

resource "github_repository_collaborator" "collaborator" {
  for_each = local.collaborators

  repository = github_repository.repository.name
  username   = each.key
  permission = each.value
}

# ---------------------------------------------------------------------------------------------------------------------
# Teams by id
# ---------------------------------------------------------------------------------------------------------------------

locals {
  team_id_admin    = [for i in var.admin_team_ids : { team_id = i, permission = "admin" }]
  team_id_push     = [for i in var.push_team_ids : { team_id = i, permission = "push" }]
  team_id_pull     = [for i in var.pull_team_ids : { team_id = i, permission = "pull" }]
  team_id_triage   = [for i in var.triage_team_ids : { team_id = i, permission = "triage" }]
  team_id_maintain = [for i in var.maintain_team_ids : { team_id = i, permission = "maintain" }]

  team_ids = concat(
    local.team_id_admin,
    local.team_id_push,
    local.team_id_pull,
    local.team_id_triage,
    local.team_id_maintain,
  )
}

resource "github_team_repository" "team_repository" {
  count = length(local.team_ids)

  repository = github_repository.repository.name
  team_id    = local.team_ids[count.index].team_id
  permission = local.team_ids[count.index].permission
}

# ---------------------------------------------------------------------------------------------------------------------
# Teams by name
# ---------------------------------------------------------------------------------------------------------------------

locals {
  team_admin    = [for i in var.admin_teams : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "admin" }]
  team_push     = [for i in var.push_teams : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "push" }]
  team_pull     = [for i in var.pull_teams : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "pull" }]
  team_triage   = [for i in var.triage_teams : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "triage" }]
  team_maintain = [for i in var.maintain_teams : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "maintain" }]

  teams = { for i in concat(
    local.team_admin,
    local.team_push,
    local.team_pull,
    local.team_triage,
    local.team_maintain,
  ) : i.slug => i }
}

resource "github_team_repository" "team_repository_by_slug" {
  for_each = local.teams

  repository = github_repository.repository.name
  team_id    = each.value.slug
  permission = each.value.permission

}
