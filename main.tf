module "hivemq_github" {
  source         = "./module"
  name           = "cfabrizio-repo-test"
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
    },
    {
      name = "playground"
    }
  ]

  admin_team_ids = ["sre"]

}