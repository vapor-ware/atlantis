FROM vaporio/foundation:latest as builder
ADD https://github.com/vapor-ware/sctl/releases/download/1.4.2/sctl_1.4.2_Linux_x86_64.tar.gz /tmp/sctl.tar.gz
WORKDIR /tmp
RUN tar xvfz sctl.tar.gz

FROM runatlantis/atlantis:v0.16.0
COPY --from=0 /tmp/sctl /usr/local/bin/sctl

# install terraform binaries
ENV NEEDED_TERRAFORM_VERSIONS="0.12.29 0.13.6 0.14.3"
ENV DEFAULT_TERRAFORM_VERSION=0.14.3

# In the official Atlantis image we only have the latest of each Terraform version.
RUN AVAILABLE_TERRAFORM_VERSIONS="${NEEDED_TERRAFORM_VERSIONS}" && \
    rm -f /usr/local/bin/terraform && \
    for VERSION in ${AVAILABLE_TERRAFORM_VERSIONS}; do \
        curl -LOs https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip && \
        curl -LOs https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_SHA256SUMS && \
        sed -n "/terraform_${VERSION}_linux_amd64.zip/p" terraform_${VERSION}_SHA256SUMS | sha256sum -c && \
        mkdir -p /usr/local/bin/tf/versions/${VERSION} && \
        unzip -o terraform_${VERSION}_linux_amd64.zip -d /usr/local/bin/tf/versions/${VERSION} && \
        ln -fs /usr/local/bin/tf/versions/${VERSION}/terraform /usr/local/bin/terraform${VERSION} && \
        rm terraform_${VERSION}_linux_amd64.zip && \
        rm terraform_${VERSION}_SHA256SUMS; \
    done && \
    ln -s /usr/local/bin/tf/versions/${DEFAULT_TERRAFORM_VERSION}/terraform /usr/local/bin/terraform

