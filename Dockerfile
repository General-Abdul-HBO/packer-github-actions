# see https://hub.docker.com/r/hashicorp/packer/tags for all available tags
FROM hashicorp/packer:light@sha256:1e298ef74fc816654238f7c17ea0f0636c2e19d3baf77ed5f795b7f976a4ba96
LABEL maintainer="Chef Software, Inc. <docker@chef.io>"

ARG ANSIBLE_VERSION=3.2.0
ARG VERSION=5.18.14
ARG CHANNEL=stable
LABEL ansibleVersion=$ANSIBLE_VERSION

ARG ANSIBLE_LINT_VERSION=5.0.7

ENV PATH=/opt/inspec/bin:/opt/inspec/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apk --update --no-cache add \
    ca-certificates \
    git \
    openssh-client \
    openssl \
    python3\
    py3-pip \
    py3-cryptography \
    rsync \
    sshpass \
    wget rpm2cpio cpio \
    && wget -q "https://packages.chef.io/files/${CHANNEL}/inspec/${VERSION}/el/8/inspec-${VERSION}-1.el8.x86_64.rpm" -O /tmp/inspec.rpm && \
    rpm2cpio /tmp/inspec.rpm | cpio -idmv && \
    rm -rf /tmp/inspec.rpm

RUN apk --update add --virtual \
    .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    && pip3 install --upgrade \
    pip \
    cffi \
    && pip3 install \
    ansible==${ANSIBLE_VERSION} \
    ansible-lint==${ANSIBLE_LINT_VERSION} \
    && apk del \
    .build-deps \
    && rm -rf /var/cache/apk/*

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh", "inspec"]