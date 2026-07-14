terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
  }
  required_version = "~>1.12.0"
}

provider "vault" {
  address         = "http://127.0.0.1:8200"
  skip_tls_verify = true
  token           = "education"
  # checkov:skip=CKV_SECRET_6: dev-режим, токен education из задания
}
