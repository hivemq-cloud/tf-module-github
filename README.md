# terraform-github-module

A terrafomr module for creating private repository into the GitHub organization space HiveMQ.

**_This module supports Terraform v1.x and is compatible with the Official Terraform GitHub Provider v4.20 and above from `integrations/github`._**

# Intro

The purpose of this module is to facilitate the creation of a repository with everything in place, such as permission and branch protection, also a few templates have been introduced.

## Module feature

Beside the normal repository creation, this module offers other features like Branch Protection, Team Management etc.

- **Default Security Settings**:
  This module creates a `private` repository by default into the `org:hivemq-cloud`

- **Standard Repository Features**:
  Setting basic Metadata,
  Merge Strategy,
  Auto Init,
  Template Repository

- **Extended Repository Features**:
  Branches,
  Branch Protection,
  Teams

## How to run it

```hcl
module "hivemq_github" {
  source         = "./module"
  name           = "example-repo-test"
  description    = "This is a repo test"
  auto_init      = true
  default_branch = "main"

  template = {
    repository           = "sre-repo-template"
    owner                = "hivemq-cloud"
    include_all_branches = false
  }

  branches = [
    {
      name = "development"
    }
  ]

  admin_team_ids = ["sre"]

}
```

## Module Argument Reference

Always refer to the [variables.tf], it might be that the doc is not updated to the last release.
Be aware as mentioned some of the parameters are set by default, like

```hcl
  has_issues             = true
  has_discussions        = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
```


- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The name of the repository.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  A description of the repository.

  Default is `""`.

- [**`default_branch`**](#var-default_branch): *(Optional `string`)*<a name="var-default_branch"></a>

  The name of the default branch of the repository.
  NOTE: The configured default branch must exist in the repository.
  If the branch doesn't exist yet, or if you are creating a new
  repository, please add the desired default branch to the `branches`
  variable, which will cause Terraform to create it for you.

  Default is `""`.

- [**`auto_init`**](#var-auto_init): *(Optional `bool`)*<a name="var-auto_init"></a>

  Set to `false` to not produce an initial commit in the repository.

  Default is `true`.

- [**`template`**](#var-template): *(Optional `object(template)`)*<a name="var-template"></a>

  Use a template repository to create this resource.

  Default is `{}`.

  The `template` object accepts the following attributes:

  - [**`owner`**](#attr-template-owner): *(**Required** `string`)*<a name="attr-template-owner"></a>

    The GitHub organization or user the template repository is owned by.

  - [**`repository`**](#attr-template-repository): *(**Required** `string`)*<a name="attr-template-repository"></a>

    The name of the template repository.

#### Collaborator Configuration

- [**`pull_collaborators`**](#var-pull_collaborators): *(Optional `list(string)`)*<a name="var-pull_collaborators"></a>

  A list of user names to add as collaborators granting them pull (read-only) permission.
  Recommended for non-code contributors who want to view or discuss your project.

  Default is `[]`.

- [**`triage_collaborators`**](#var-triage_collaborators): *(Optional `list(string)`)*<a name="var-triage_collaborators"></a>

  A list of user names to add as collaborators granting them triage permission.
  Recommended for contributors who need to proactively manage issues and pull requests without write access.

  Default is `[]`.

- [**`push_collaborators`**](#var-push_collaborators): *(Optional `list(string)`)*<a name="var-push_collaborators"></a>

  A list of user names to add as collaborators granting them push (read-write) permission.
  Recommended for contributors who actively push to your project.

  Default is `[]`.

- [**`maintain_collaborators`**](#var-maintain_collaborators): *(Optional `list(string)`)*<a name="var-maintain_collaborators"></a>

  A list of user names to add as collaborators granting them maintain permission.
  Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.

  Default is `[]`.

- [**`admin_collaborators`**](#var-admin_collaborators): *(Optional `list(string)`)*<a name="var-admin_collaborators"></a>

  A list of user names to add as collaborators granting them admin (full) permission.
  Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository.

  Default is `[]`.


#### Teams Configuration

Your can use non-computed (known at `terraform plan`) team names or slugs (`*_teams` Attributes)
or computed (only known in `terraform apply` phase) team IDs (`*_team_ids` Attributes).
**When using non-computed names/slugs teams need to exist before running plan.**
This is due to some terraform limitation and we will update the module once terraform removed this limitation.

- [**`pull_teams`**](#var-pull_teams): *(Optional `list(string)`)*<a name="var-pull_teams"></a>

  Can also be `pull_team_ids`. A list of teams to grant pull (read-only) permission.
  Recommended for non-code contributors who want to view or discuss your project.

  Default is `[]`.

- [**`triage_teams`**](#var-triage_teams): *(Optional `list(string)`)*<a name="var-triage_teams"></a>

  Can also be `triage_team_ids`. A list of teams to grant triage permission.
  Recommended for contributors who need to proactively manage issues and pull requests
  without write access.

  Default is `[]`.

- [**`push_teams`**](#var-push_teams): *(Optional `list(string)`)*<a name="var-push_teams"></a>

  Can also be `push_team_ids`. A list of teams to grant push (read-write) permission.
  Recommended for contributors who actively push to your project.

  Default is `[]`.

- [**`maintain_teams`**](#var-maintain_teams): *(Optional `list(string)`)*<a name="var-maintain_teams"></a>

  Can also be `maintain_team_ids`. A list of teams to grant maintain permission.
  Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.

  Default is `[]`.

- [**`admin_teams`**](#var-admin_teams): *(Optional `list(string)`)*<a name="var-admin_teams"></a>

  Can also be `admin_team_ids`. A list of teams to grant admin (full) permission.
  Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository.

  Default is `[]`.

- [**`branches`**](#var-branches): *(Optional `list(branch)`)*<a name="var-branches"></a>

  Create and manage branches within your repository.
  Additional constraints can be applied to ensure your branch is created from another branch or commit.

  Default is `[]`.

  Each `branch` object in the list accepts the following attributes:

  - [**`name`**](#attr-branches-name): *(**Required** `string`)*<a name="attr-branches-name"></a>

    The name of the branch to create.

#### Branch Protection

By default we have applyed only two rules

```hcl
resource "github_branch_protection_v3" "main" {
  repository             = github_repository.repository.name
  branch                 = "main"
  enforce_admins         = true
  require_signed_commits = true

  required_pull_request_reviews {
    required_approving_review_count = 0
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
```
these rules cover pretty much all our need.

## External Documentation

### Terraform Github Provider Documentation

- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator


## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.




## Destroy resource 

Unfortunately due to some terraform limitation the destroy/delete of a resource needs to be done using the `-target` flag.

```hcl
terraform destroy -target=module.hivemq_github
```
once done we can remove the configuration from the [main.tf].

Be aware that the repo by default will be archived, and the complete destroy needs to be done via GUI since the MFA is required.




<!-- References -->
[variables.tf]:
[main.tf]: 