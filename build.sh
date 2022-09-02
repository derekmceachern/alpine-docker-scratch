#!/bin/bash

# Exit on error and turn on trace since I'm lazy and didn't
# add any logging
#
set -ex

# Set the version of alpine linux that we want to use and the
# name of the image we are going to create
#
ALPINE_VER="${ALPINE_VER:-3.16}"
DKR_IMAGE="derekm/alpine:${ALPINE_VER}"

# Set the list of packages that we want to install in the base image
# For a list of possible packages you can sift through the following
#  http://dl-cdn.alpinelinux.org/alpine/
#    http://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86_64/
#
PACKAGES="apk-tools ca-certificates bash ssl_client"

#######################################################################

CURRDIR=$(/bin/dirname $(/bin/readlink -f "$0"))
MKROOTFS="${CURRDIR}/alpine-make-rootfs"
BUILD_TAR="${CURRDIR}/alpine-rootfs-${ALPINE_VER}.tar.gz"
POST_INSTALL="./post-install.sh"

# Clean up artifacts from previous builds
#
rm -rf "${MKROOTFS}"
rm -f "${BUILD_TAR}"
rm -f Dockerfile
docker image rm -f "${DKR_IMAGE}"

# Download version of apline-make-rootfs from github
# There may be a new version of the script and sha1sum
# if a new version of Alpine has been released.
# Check the following github repo for details: 
#  https://github.com/alpinelinux/alpine-make-rootfs
#
wget https://raw.githubusercontent.com/alpinelinux/alpine-make-rootfs/v0.6.1/alpine-make-rootfs -O "$MKROOTFS"
echo "73948b9ee3580d6d9dc277ec2d9449d941e32818  alpine-make-rootfs" | sha1sum -c -
chmod +x "${MKROOTFS}"

# Run the make rootfs script. It needs to run as root.
# In this case I'm calling sudo with -E to pass environment
# variables since I'm behind a proxy and I have
# http_proxy/https_proxy/no_proxy environment variables set that
# root needs to successfully run this script
#
sudo -E "${MKROOTFS}" --mirror-uri http://dl-2.alpinelinux.org/alpine \
     --branch "v${ALPINE_VER}" \
     --packages "${PACKAGES}" \
     --script-chroot \
     "${BUILD_TAR}" \
     "${POST_INSTALL}"

# Create the Dockerfile which will be used for building
# the image
#
cat <<DOCKERFILE > "${CURRDIR}/Dockerfile"
FROM scratch
USER gonzo
ADD $(basename "${BUILD_TAR}") /
CMD ["/bin/bash"]
DOCKERFILE

# Build the Docker image
#
cd "${CURRDIR}"
docker build --no-cache -t "${DKR_IMAGE}" .

cd "${CURRDIR}"

exit 0
