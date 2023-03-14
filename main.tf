module "hivemq_github" {
  source         = "./module"
  name           = "deployment-apiary-starter-staging"
  description    = "Repo for the staging env running the starter edition"
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
    },
    {
      name = "staging"
    }
  ]

  admin_team_ids = ["sre"]

}