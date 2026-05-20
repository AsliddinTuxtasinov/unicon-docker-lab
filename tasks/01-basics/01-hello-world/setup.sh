#!/usr/bin/env bash
set -e
# Ensure docker daemon is ready
timeout 30 bash -c 'until docker info &>/dev/null; do sleep 1; done'