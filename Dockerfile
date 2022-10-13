# see https://hub.docker.com/r/hashicorp/packer/tags for all available tags
FROM hashicorp/packer:light@sha256:1e298ef74fc816654238f7c17ea0f0636c2e19d3baf77ed5f795b7f976a4ba96

RUN apk update && \
    apk upgrade && \
    apk add curl && \
    apk add go && \
    apk add ansible && \
    apk add wget rpm2cpio cpio && \
    wget "http://packages.chef.io/files/${CHANNEL}/inspec/${VERSION}/el/7/inspec-${VERSION}-1.el7.x86_64.rpm" -O /tmp/inspec.rpm && \
    rpm2cpio /tmp/inspec.rpm | cpio -idmv && \
    rm -rf /tmp/inspec.rpm


RUN rm -rf /var/cache/apk/*

COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
