# Add Realm
# Client Add(grafana)
* Client ID : grafana
* Client Protocol : openid-connect
* Access Type : confidentail
* Authorization Enabled
* Root_URL : grafana_endpoint

# grafana confing
```
grafana.ini: |
..
[server]
    protocol = http
    http_port = 3000
    domain = grafana.example.sk.copm
    enforce_domain = true
    root_url = %(protocol)s://%(domain)s/
    ;router_logging = false
    ;static_root_path = public
    ;enable_gzip = false
    ;cert_file =
    ;cert_key =


[auth.generic_oauth]
    name = OAuth
    enabled = true
    allow_sign_up = true
    client_id = grafana
    client_secret = [grafana_secret]
    scopes = openid email name
    auth_url = http://[keyclock]/auth/realms/[realm_name]/protocol/openid-connect/auth
    token_url = http://[keyclock]/auth/realms/[realm_name]/protocol/openid-connect/token
    ;api_url =
    ;team_ids =
    ;allowed_organizations =
```
