disable_mlock = true
ui=true

storage "raft" {
   path    = "/home/joe/Public/hashicorp/vault/vault"
   node_id = "node1"
}

listener "tcp" {
  address     = "127.0.0.1:8100"
  tls_disable = "true"
  proxy_protocol_behavior = "use_always"
}

seal "transit" {
  address = "http://127.0.0.1:8200"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}

api_addr = "http://127.0.0.1:8100"
cluster_addr = "https://127.0.0.1:8101"