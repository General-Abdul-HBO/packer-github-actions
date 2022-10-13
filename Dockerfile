# see https://hub.docker.com/r/hashicorp/packer/tags for all available tags
FROM hashicorp/packer:light@sha256:1e298ef74fc816654238f7c17ea0f0636c2e19d3baf77ed5f795b7f976a4ba96

RUN apk update && \
    apk upgrade && \
    apk add curl && \
    apk add go && \
    apk add ansible && \
    apk add git && \
    apk add wget rpm2cpio cpio && \
    wget "https://packages.chef.io/files/stable/inspec/5.18.14/el/8/inspec-5.18.14-1.el8.x86_64.rpm" -O /tmp/inspec.rpm && \
    rpm2cpio /tmp/inspec.rpm | cpio -idmv && \
    rm -rf /tmp/inspec.rpm


RUN rm -rf /var/cache/apk/*

COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh" "inspec"]
