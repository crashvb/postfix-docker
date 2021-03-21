FROM crashvb/supervisord:202103210039
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

# Install packages, download files ...
RUN docker-apt postfix postfix-pcre

# Configure: postfix
ENV POSTFIX_CONFIG=/etc/postfix POSTFIX_VGID=5000 POSTFIX_VMAIL=/var/mail POSTFIX_VNAME=vmail POSTFIX_VUID=5000
ADD postfix-* test-mail /usr/local/bin/
RUN groupadd -g ${POSTFIX_VGID} ${POSTFIX_VNAME} && \
	useradd --create-home --gid=${POSTFIX_VGID} --home-dir=/home/${POSTFIX_VNAME} --shell=/usr/bin/nologin --uid=${POSTFIX_VUID} ${POSTFIX_VNAME} && \
	install --directory --group=root --mode=0775 --owner=root /usr/local/share/postfix && \
	install --directory --group=vmail --owner=vmail ${POSTFIX_VMAIL} && \
	cp --preserve ${POSTFIX_CONFIG}/main.cf ${POSTFIX_CONFIG}/main.cf.dist && \
	postconf -c ${POSTFIX_CONFIG} -e \
		"lmtp_host_lookup = native" \
		"local_transport = virtual" \
		"maillog_file = /dev/stdout" \
		"mydestination = pcre:${POSTFIX_CONFIG}/mydestination" \
		"myorigin = ${POSTFIX_CONFIG}/mailname" \
		"smtpd_tls_auth_only = yes" \
		"smtpd_tls_CAfile = /etc/ssl/certs/postfixca.crt" \
		"smtpd_tls_cert_file = /etc/ssl/certs/postfix.crt" \
		"smtpd_tls_exclude_ciphers = aNULL,eNULL,EXPORT,DES,3DES,RC2,RC4,MD5,PSK,SRP,DSS,AECDH,ADH,SEED" \
		"smtpd_tls_key_file = /etc/ssl/private/postfix.key" \
		"smtpd_tls_mandatory_protocols = !SSLv2,!SSLv3,!TLSv1,!TLSv1.1" \
		"smtpd_tls_received_header = yes" \
		"smtpd_tls_security_level = encrypt" \
		"virtual_gid_maps = static:${POSTFIX_VGID}" \
		"virtual_uid_maps = static:${POSTFIX_VUID}" \
		"virtual_mailbox_base = ${POSTFIX_VMAIL}" \
		"virtual_minimum_uid = ${POSTFIX_VUID}" && \
	postconf -c ${POSTFIX_CONFIG} -n | \
		sort > /tmp/main.cf && \
		cat /tmp/main.cf > ${POSTFIX_CONFIG}/main.cf && \
		rm --force /tmp/main.cf && \
	sed --expression="/^smtp      inet/s/^/#/" \
		--expression="/^#smtps /{s/^#//;s/y/-/}" \
		--expression="/^smtps /,+3 s/^#//" \
		--in-place=.dist ${POSTFIX_CONFIG}/master.cf && \
	mv /etc/aliases* ${POSTFIX_CONFIG} && \
	echo "localhost" > ${POSTFIX_CONFIG}/mailname && \
	bash -c "ln --symbolic ${POSTFIX_CONFIG}/{aliases,aliases.db,mailname} /etc/" && \
	mv ${POSTFIX_CONFIG} /usr/local/share/postfix/config

# Configure: supervisor
ADD supervisord.postfix.conf /etc/supervisor/conf.d/postfix.conf

# Configure: entrypoint
ADD entrypoint.postfix /etc/entrypoint.d/postfix

# Configure: healthcheck
ADD healthcheck.postfix /etc/healthcheck.d/postfix

EXPOSE 25/tcp 465/tcp 587/tcp

VOLUME /var/spool/postfix ${POSTFIX_CONFIG} ${POSTFIX_VMAIL}
