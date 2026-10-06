#!/usr/bin/env bash

set -euo pipefail
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
IMAGE="dott-site-tester"

docker build --tag "$IMAGE" "$BASE_DIR"
docker run --rm --interactive --tty \
	--network host \
	--volume "$BASE_DIR/.sites:/dott/.sites:ro" \
	"$IMAGE"
