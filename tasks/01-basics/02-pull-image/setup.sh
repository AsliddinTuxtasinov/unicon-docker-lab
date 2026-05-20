#!/usr/bin/env bash
set -e
timeout 30 bash -c 'until docker info &>/dev/null; do sleep 1; done'