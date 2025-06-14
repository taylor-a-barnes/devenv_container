#!/bin/sh

IMAGE=taylorabarnes/devenv:latest

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Image not found locally. Pulling $IMAGE..."
    if ! docker pull "$IMAGE"; then
        echo "Failed to pull image $IMAGE." >&2
        exit 1
    fi
    echo ""
    echo ""
    echo ""
fi

# Copy the run script from the image
CID=$(docker create $IMAGE)
docker cp $CID:/interface.sh .interface.sh
docker rm -v $CID

# Run the image's interface script
bash .interface.sh
