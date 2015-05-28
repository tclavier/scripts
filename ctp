#!/bin/bash

end_of_script () {
  [ -n "${1:-}" ] && EXIT="${1}" || EXIT=0
  [ -n "${2:-}" ] && echo "$2" >&2
  exit $EXIT
}


tar -czv /etc/machine-id /root/controletp.md 
