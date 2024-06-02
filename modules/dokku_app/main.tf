terraform {
  required_providers {
    dokku = {
      source  = "aliksend/dokku"
      version = "1.0.14"
    }
  }
}

variable "host" {
  type = string
}

variable "app_name" {
  type = string
}


variable "my_secrets" {
  type = map
  default = {}
}



provider "dokku" {
  ssh_host = var.host

  ssh_user = "dokku"
  ssh_port = 22
  ssh_cert = "~/.ssh/id_ed25519"
}


resource "random_password" "secret_key_base" {
  length  = 64
  special = false
}


locals {
 
 config_defaults = {
    SECRET_KEY_BASE = random_password.secret_key_base.result
    NODE_HOSTNAME   = "${var.app_name}.web"
    PORT            = "80"
    PUBLIC_HOST     = "${var.app_name}.${var.host}"
    PUBLIC_PORT     = "443"
    }

}

resource "dokku_app" "main_app" {

  app_name = var.app_name

  config=  merge(local.config_defaults, local.module_dokku_app.config)


  ports = {
    80 = {
      scheme         = "http"
      container_port = 80
    }
    443 = {
      scheme         = "https"
      container_port = 80
    }
  }

  storage = local.module_dokku_app.storage
  domains = local.module_dokku_app.domains

}

resource "dokku_letsencrypt" "main_app-letsencrypt" {
  app_name = var.app_name
  email    = "manfred@mavu.io"
  depends_on = [dokku_app.main_app]
}


# resource "dokku_postgres" "main_app-postgres" {
#   service_name = var.mavu_dokku_pg_name
# }

# resource "dokku_postgres_link" "main_app-postgres-link" {
#   app_name     = var.mavu_dokku_app_name
#   service_name = var.mavu_dokku_pg_name
# }


