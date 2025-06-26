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
    curl -o /tmp/fedora.gpg https://fedoraproject.org/fedora.gpg && \
    rpm --import /tmp/fedora.gpg && \
    zypper install --no-confirm kernel-default libostree libostree-grub2 grub2 grub2-x86_64-efi grub2-common nano curl dracut fastfetch && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/bootc-1.1.6-3.fc42.x86_64.rpm && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/bootupd-0.2.26-3.fc42.x86_64.rpm && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/grub2-pc-2.12-28.fc42.x86_64.rpm && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/grub2-pc-modules-2.12-28.fc42.noarch.rpm && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/grub2-tools-minimal-2.12-28.fc42.x86_64.rpm && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/rpm-ostree-2025.6-6.fc42.x86_64.rpm && \
    zypper install --no-confirm --allow-unsigned-rpm /ctx/rpms/rpm-ostree-libs-2025.6-6.fc42.x86_64.rpm && \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
