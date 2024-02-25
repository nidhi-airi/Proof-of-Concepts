# here the provider github is used to use github plugin using terraform
provider github {
  version      = "~> 2.1"
  organization = "${var.org_name}"
  token        = "${var.token_name}"
}
resource "github_membership" "member" {
  username     = "${var.git_user}"
  role         = "${var.git_user_role}"
}

# Add a repository to you organisation
resource "github_repository" "repository" {
  for_each           = var.repo_name
  name               = each.value.name 
  description        = "This repository is created using terraform."
  private            = false
  allow_merge_commit = true
  auto_init          = true # to produce an initial commit in the repository.
  license_template   = "mit" #(optional) 
}

# # Configure a branch protection for the repository
resource "github_branch_protection" "repository" {
  for_each       = var.repo_name
  repository     = each.value.name
  branch         = "${var.branch_name}" # here u need to update the branch you want to set the rules for
  enforce_admins = true # enforces status checks for repository administrators

  required_status_checks { # Require branches to be up to date before merging.
    strict   = true
    contexts = ["ci/travis"]
  }

  required_pull_request_reviews { # Enforce restrictions for pull request reviews.
    dismiss_stale_reviews = true
  }
  depends_on = [
    github_repository.repository,
  ]
}

