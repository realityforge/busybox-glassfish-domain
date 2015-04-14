FROM realityforge/busybox-glassfish
MAINTAINER Peter Donald <peter@realityforge.org>

RUN \
  export PASSWORD=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 10 | xargs)  && \
  echo "AS_ADMIN_PASSWORD=${PASSWORD}" > ${GLASSFISH_DOMAINS_DIR}/appserver_admin_passwd && \
  echo "AS_ADMIN_MASTERPASSWORD=${PASSWORD}" >> ${GLASSFISH_DOMAINS_DIR}/appserver_admin_passwd && \
  ${GLASSFISH_BASE_DIR}/glassfish/bin/asadmin --user admin --passwordfile ${GLASSFISH_DOMAINS_DIR}/appserver_admin_passwd create-domain --checkports=false --savemasterpassword=false --instanceport 8080 --adminport 4848 --nopassword=false --domaindir ${GLASSFISH_DOMAINS_DIR} appserver && \
  ${GLASSFISH_BASE_DIR}/glassfish/bin/asadmin --user admin --passwordfile ${GLASSFISH_DOMAINS_DIR}/appserver_admin_passwd start-domain --domaindir ${GLASSFISH_DOMAINS_DIR} appserver && \
  ${GLASSFISH_BASE_DIR}/glassfish/bin/asadmin --user admin --passwordfile ${GLASSFISH_DOMAINS_DIR}/appserver_admin_passwd enable-secure-admin && \
  ${GLASSFISH_BASE_DIR}/glassfish/bin/asadmin --user admin --passwordfile ${GLASSFISH_DOMAINS_DIR}/appserver_admin_passwd stop-domain --domaindir ${GLASSFISH_DOMAINS_DIR} appserver && \
  rm -rf /srv/glassfish/.gfclient

EXPOSE 8080 4848

CMD ["asadmin", "--user", "admin", "--passwordfile", "/srv/glassfish/domains/appserver_admin_passwd", "start-domain", "--domaindir", "/srv/glassfish/domains", "--verbose=true"]