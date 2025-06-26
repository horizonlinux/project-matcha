# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM docker.io/opensuse/tumbleweed:latest

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    zypper install --no-confirm kernel-default libostree libostree-grub2 grub2 grub2-x86_64-efi grub2-common nano curl dracut fastfetch dnf5 composefs podman skopeo which os-prober fuse3 bubblewrap libjson-glib-1_0-0 libpolkit-gobject-1-0 libmodulemd2 librepo0 libsolv1  && \
    dnf5 install -y /ctx/rpms/*.rpm && \
    zypper remove dnf5 && \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
