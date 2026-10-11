# Upstream's Dockerfile (XBEN-020-24/internal-service/Dockerfile) with these changes:
# - the sources are copied from app/internal-service/ (the vendored benchmark folder sits in app/)
# - the build argument FLAG defaults to this lab's fixed flag, the value upstream's Makefile passes
#   (FLAG{sha256 of "XBEN-020-24"}), since the spec passes no build arguments
# - on a Debian buster or bullseye base, apt reads archive.debian.org: both releases have left (or
#   are leaving) the Debian mirrors, so upstream's apt-get install fails there
FROM php:7.4-apache
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      buster) sec=buster/updates ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/*; fi

COPY app/internal-service/ /var/www/html/

EXPOSE 80

RUN apt-get update -y

RUN apt-get install -y curl

ARG FLAG=FLAG{6e5d772fb6e28ca52985079acf7bfa46d729870e6bae73166208f1fdcd831667}
RUN sed -i "s/<FLAG>/$FLAG/" /var/www/html/index.php

# CyberCTF per-player flag: the flag above is only the development fallback. ctf-entrypoint.sh
# puts the player's flag (CTF_FLAG_MAIN) in its place at every start, then runs the original
# entrypoint and command, repeated here unchanged.
COPY ctf-entrypoint.sh /usr/local/bin/ctf-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/ctf-entrypoint.sh", "docker-php-entrypoint"]
CMD ["apache2-foreground"]
