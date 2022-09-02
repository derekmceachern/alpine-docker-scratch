# Build Docker Image for Alpine Linux from Scratch

This builds a Docker image of a minimal Alpine Linux distribution from scratch.

Why would I do this instead of just using the [official Alpine Docker image](https://hub.docker.com/_/alpine)? I wanted to learn how to create an image from scratch that wasn't one of the really simple examples of "write your own statically linked executable and put that in the container". I was looking for something that ended up looking more like a linux distribution that I could then install an application like Apache.

## Overview

The overall process is pretty simple.

* Using the [Make Alpine Linux RootFS](https://github.com/alpinelinux/alpine-make-rootfs) script create a RootFS configured with your desired packages and create a non-root user.
* Create a `Dockerfile`
* Build image.

## Usage

The main script is `build.sh`.

The `post-install.sh` script is used during the build process to update packages and add a non-root user.

There are no fancy command line options but there should be enough comments in scripts to figure out what is going on.

## Credits

I need to give credit to [Dave Hall](https://github.com/skwashd/alpine-docker-from-scratch) where I found the basis for this code. I've modified it to meet my needs.
