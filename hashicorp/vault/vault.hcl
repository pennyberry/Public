# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

# Full configuration options can be found at https://developer.hashicorp.com/vault/docs/configuration

ui = true
cluster_addr  = "https://social.joeberry.org:8201"
api_addr      = "https://social.joeberry.org:8200"

#disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

storage "raft" {
  path    = "/opt/vault/data"
  node_id = "1"

  retry_join {
    leader_tls_servername   = "social.joeberry.org"
    leader_api_addr         = "https://social.joeberry.org:8200"
    leader_ca_cert_file     = "/opt/vault/tls/vault-ca.pem"
    leader_client_cert_file = "/opt/vault/tls/vault-cert.pem"
    leader_client_key_file  = "/opt/vault/tls/vault-key.pem"
  }
}

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/etc/letsencrypt/live/social.joeberry.org/fullchain.pem"
  tls_key_file  = "/etc/letsencrypt/live/social.joeberry.org/privkey.pem"
}

# Example AWS KMS auto unseal
#seal "awskms" {
#  region = "us-east-1"
#  kms_key_id = "REPLACE-ME"
#}

# Example HSM auto unseal
#seal "pkcs11" {
#  lib            = "/usr/vault/lib/libCryptoki2_64.so"
#  slot           = "0"
#  pin            = "AAAA-BBBB-CCCC-DDDD"
#  key_label      = "vault-hsm-key"
#  hmac_key_label = "vault-hsm-hmac-key"
#}