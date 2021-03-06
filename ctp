#!/bin/bash

end_of_script () {
  [ -n "${1:-}" ] && EXIT="${1}" || EXIT=0
  [ -n "${2:-}" ] && echo "$2" >&2
  exit $EXIT
}
apt-get install -y gzip tar
dpkg -l > /root/debs

tar -czvf /tmp/ctp.tgz --ignore-failed-read \
  /etc/apache2 \
  /etc/apt \
  /etc/locale.gen \
  /etc/machine-id \
  /etc/munin \
  /etc/network/interfaces \
  /etc/passwd \
  /etc/sudoers \
  /home \
  /root/.ssh \
  /root/controletp.md \
  /root/debs \
  /root/lshome \
  /var/log/auth.log \
  /var/www 

