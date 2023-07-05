# Kokuten

## Development

```bash
$ vim .env
RAILS_MASTER_KEY=<master_key>
MYSQL_ROOT_PASSWORD=<password>
WEBAUTHN_ORIGIN=<https://localhost:3000>

$ docker compose -f compose.development.yml up -d
```

## Deployment

```bash
$ vim .env
RAILS_MASTER_KEY=<master_key>
MYSQL_ROOT_PASSWORD=<password>
WEBAUTHN_ORIGIN=<https://example.com>
APP_HOST=<example.com>
CERT_MAIL=<shmn7iii@example.com>

$ bash bin/certbot

$ docker compose up -d
```
