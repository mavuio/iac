# terraform {
#   required_providers {
#     github = {
#       source  = "integrations/github"
#       version = "5.41.0"
#     }
#   }
# }

# locals {
#   repository_name = "evm-www"
#   github_owner    = "mavuio"
# }


# provider "github" {
#   owner = local.github_owner
# }

# resource "github_repository" "evm_containerized" {
#   name                   = local.repository_name
#   description            = "iac template for running evm-applications"
#   visibility             = "private"
#   has_issues             = false
#   auto_init              = true
#   gitignore_template     = "Terraform"
#   delete_branch_on_merge = false
# }
