#!/bin/bash
# Usage: .pfnci/script.sh [target]
# - target is a test target (e.g., "chainer-ci-prep.py37").
#
# For testing this script, set DRYRUN=1 as an environment variable and run the
# script.  It will print commands without execution.
# $ DRYRUN=1 bash .pfnci/script.sh chainer-ci-prep.py37

set -eu

cd "$(dirname "${BASH_SOURCE}")"/..

main() {
  TARGET="$1"

  prepare_docker &
  wait

  docker_args=(docker run  --rm --volume="$(pwd):/src:ro")

  case "${TARGET}" in
    'chainer-ci-prep.py37' | 'chainer-ci-prep.py27and35' )
      run docker build -t "asia.gcr.io/pfn-public-ci/${TARGET}" \
          -f ".pfnci/${TARGET}.Dockerfile" .
      run docker push "asia.gcr.io/pfn-public-ci/${TARGET}"
      ;;
    * )
      echo "Unsupported target: ${TARGET}" >&2
      exit 1
      ;;
  esac
}

# run executes a command.  If DRYRUN is enabled, run just prints the command.
run() {
  echo '+' "$@"
  if [ "${DRYRUN:-}" == '' ]; then
    "$@"
  fi
}

# prepare_docker makes docker use tmpfs to speed up.
# CAVEAT: Do not use docker during this is running.
prepare_docker() {
  if [ "${CI:-}" != '' ]; then
    run service docker stop
    run mount -t tmpfs -o size=100% tmpfs /var/lib/docker
    run service docker start
  fi
  run gcloud auth configure-docker
}

main "$@"
