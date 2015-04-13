#!/bin/sh
[ "$1" ] || {
    echo "Specify tarmaker directory to use:"
    ls -1 -d tarmaker-*
    exit 1
}
[ -d "$1" ] || {
    echo "Could not find directory $1."
    exit 1
}
TARMAKER_IMAGE=tarmaker32-$1
docker build -t "$TARMAKER_IMAGE" $1 || {
    echo "Something went wrong when building the builder. Aborting."
    exit 1
}
[ -f $1/rootfs.tar ] && mv $1/rootfs.tar $1/rootfs.tar.old
docker run "$TARMAKER_IMAGE" cat /rootfs.tar > $1/rootfs.tar
rm -f rootfs.tar
# We use cp rather than ln because ln doesn't work well on VBox shared folders.
cp $1/rootfs.tar rootfs.tar
ls -ltr rootfs.tar */rootfs.tar*
echo "You can now build the busybox image, with:"
echo "docker build -t wtanaka/busybox32 ."
