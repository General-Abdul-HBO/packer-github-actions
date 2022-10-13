# see https://hub.docker.com/r/hashicorp/packer/tags for all available tags
FROM hashicorp/packer:light@sha256:1e298ef74fc816654238f7c17ea0f0636c2e19d3baf77ed5f795b7f976a4ba96

USER root

ARG MITOGEN_VERSION=0.2.9
ARG ANSIBLE_VERSION=3.2.0
LABEL ansibleVersion=$ANSIBLE_VERSION

ARG ANSIBLE_LINT_VERSION=5.0.7
RUN apk --update --no-cache add \
    ca-certificates \
    git \
    openssh-client \
    openssl \
    python3\
    py3-pip \
    py3-cryptography \
    rsync \
    sshpass

RUN apk --update add --virtual \
    .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    curl \
    && curl -s -L -O "https://packages.chef.io/files/stable/inspec/5.18.14/el/8/inspec-5.18.14-1.el8.x86_64.rpm" \
    && mv inspec-* /tmp/ \
    && chown root:root /tmp/inspec-* \
    && chmod 700 /tmp/inspec-* \
    && /tmp/inspec-* \
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
ENTRYPOINT ["/entrypoint.sh"]