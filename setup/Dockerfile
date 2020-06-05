FROM debian:buster
RUN apt-get -qqy update && apt-get -qyy install mariadb-client restic ca-certificates && apt-get clean
COPY ./*.sh /srv/bfsetup/
ENTRYPOINT /srv/bfsetup/docker-entrypoint.sh
HEALTHCHECK --interval=10s --timeout=1m CMD /srv/bfsetup/healthcheck.sh
