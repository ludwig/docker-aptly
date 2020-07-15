#!/bin/bash
# Build the docker-aptly image.

IMAGE_TAG=ludwig/aptly:latest

readonly script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

# User docker buildkit to build.
export DOCKER_BUILDKIT=1

# Use one of: auto, plain, tty
export BUILDKIT_PROGRESS=plain

set -x
docker build -t "${IMAGE_TAG}" "${script_dir}"
