FROM debian:buster
RUN apt-get -qqy update && apt-get -qyy install rsync mariadb-client restic ca-certificates && apt-get clean
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT /usr/local/bin/docker-entrypoint.sh
HEALTHCHECK --interval=10s --timeout=1m CMD /srv/bfsetup/healthcheck.sh
