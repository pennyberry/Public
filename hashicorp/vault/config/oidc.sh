source /home/joe/Public/hashicorp/vault/env-vars.env
vault auth enable oidc
cat reader.hcl | vault policy write reader -
vault write auth/oidc/config oidc_discovery_url="https://social.joeberry.org/keycloak/realms/joe" oidc_client_id="vault" oidc_client_secret="${OIDC_SECRET}" default_role=reader
vault write auth/oidc/role/reader allowed_redirect_uris="https://localhost:8250/oidc/callback" allowed_redirect_uris="https://localhost:8200/ui/vault/auth/oidc/oidc/callback" user_claim="sub" policies=reader