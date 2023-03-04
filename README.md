# postfix-docker

[![version)](https://img.shields.io/docker/v/crashvb/postfix/latest)](https://hub.docker.com/repository/docker/crashvb/postfix)
[![image size](https://img.shields.io/docker/image-size/crashvb/postfix/latest)](https://hub.docker.com/repository/docker/crashvb/postfix)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/postfix-docker.svg)](https://github.com/crashvb/postfix-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [Postfix](https://www.postfix.org/).

## Entrypoint Scripts

### postfix

The embedded entrypoint script is located at `/etc/entrypoint.d/postfix` and performs the following actions:

1. The PKI certificates are generated or imported.
2. A new postfix configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | POSTFIX\_ALIASES | | Content of `POSTFIX_CONFIG`/aliases; also `/etc/aliases`. |
 | POSTFIX\_AUTH\_PATH | | If defined, the dovecot auth service will be consumed at this address. |
 | POSTFIX\_MAILNAME | _hostname_ | The mail name of the instance. |
 | POSTFIX\_MYDESTINATION | | Content of `POSTFIX_CONFIG`/mydestination. |
 | POSTFIX\_VGID | 5000 | Group ID of the virtual mail user. |
 | POSTFIX\_VIRTUAL\_ALIAS\_MAPS | | Content of `POSTFIX_CONFIG`/virtual`. |
 | POSTFIX\_VIRTUAL\_MAILBOX\_DOMAINS | | Content of `POSTFIX\_CONFIG`/virtual_mailbox_domains`. |
 | POSTFIX\_VIRTUAL\_MAILBOX\_MAPS | | Content of `POSTFIX_CONFIG`/vmailbox`. |
 | POSTFIX_VUID | 5000 | User ID of the virtual mail user. |
 | POSTFIX_VMAIL | /var/mail | Virtual mail root. |
 | POSTFIX_VNAME | vmail | Name of the virtual mail user. |


## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ postfix/
│  ├─ entrypoint.d/
│  │  └─ postfix
│  ├─ healthcheck.d/
│  │  └─ postfix
│  └─ supervisor/
│     └─ config.d/
│        └─ postfix.conf
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

