#!/bin/sh
set -e
H=http://web
# / answers with the benchmark's own page.
curl -fsS "$H/" | grep -qF 'SSRF Demo'
