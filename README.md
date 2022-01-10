# postfix-docker

## Overview

This docker image contains [Postfix](https://www.postfix.org/).

## Entrypoint Scripts

### postfix

The embedded entrypoint script is located at `/etc/entrypoint.d/postfix` and performs the following actions:

1. The PKI certificates are generated or imported.
2. A new postfix configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | POSTFIX_ALIASES | | Content of `POSTFIX_CONFIG`/aliases; also `/etc/aliases`. |
 | POSTFIX_AUTH_PATH | | If defined, the dovecot auth service will be consumed at this address. |
 | POSTFIX_CERT_DAYS | 30 | Validity period of any generated PKI certificates. |
 | POSTFIX_KEY_SIZE | 4096 | Key size of any generated PKI keys. |
 | POSTFIX_MAILNAME | _hostname_ | The mail name of the instance. |
 | POSTFIX_MYDESTINATION | | Content of `POSTFIX_CONFIG`/mydestination. |
 | POSTFIX_VGID | 5000 | Group ID of the virtual mail user. |
 | POSTFIX_VIRTUAL_ALIAS_MAPS | | Content of `POSTFIX_CONFIG`/virtual`. |
 | POSTFIX_VIRTUAL_MAILBOX_DOMAINS | | Content of `POSTFIX_CONFIG`/virtual_mailbox_domains`. |
 | POSTFIX_VIRTUAL_MAILBOX_MAPS | | Content of `POSTFIX_CONFIG`/vmailbox`. |
 | POSTFIX_VUID | 5000 | User ID of the virtual mail user. |
 | POSTFIX_VMAIL | /var/mail | Virtual mail root. |
 | POSTFIX_VNAME | vmail | Name of the virtual mail user. |


## Healthcheck Scripts

### postfix

The embedded healthcheck script is located at `/etc/healthcheck.d/postfix` and performs the following actions:

1. Verifies that all postfix services are operational.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ postfix/
│  ├─ entrypoint.d/
│  │  └─ postfix
│  └─ healthcheck.d/
│     └─ postfix
├─ run/
│  └─ secrets/
│     ├─ postfix.crt
│     ├─ postfix.key
│     └─ postfixca.crt
├─ usr/
│  └─ local/
│     └─ bin/
│        └─ postfix-test-smtp
└─ var/
   ├─ spool/
   │  └─ postfix/
   └─ mail/
```

### Exposed Ports

* `25/tcp` - SMTP unsecure port.
* `465/tcp` - SMTPS unsecure port.
* `587/tcp` - Secure Submission port.

### Volumes

* `/etc/postfix` - postfix configuration directory.
* `/var/mail` - default mail directory.

## Development

[Source Control](https://github.com/crashvb/postfix-docker)

