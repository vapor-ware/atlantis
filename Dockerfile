FROM vaporio/foundation:latest as builder

ENV SCTL_VERSION=1.5.0
ENV GCLOUD_SDK_VERSION=360.0.0

ADD https://github.com/vapor-ware/sctl/releases/download/${SCTL_VERSION}/sctl_${SCTL_VERSION}_Linux_x86_64.tar.gz /tmp/sctl.tar.gz
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz /tmp/gcloud-sdk.tar.gz
WORKDIR /tmp
RUN tar xvfz sctl.tar.gz
RUN tar xvfz gcloud-sdk.tar.gz

FROM runatlantis/atlantis:v0.16.0
COPY --from=0 /tmp/sctl /usr/local/bin/sctl
COPY --from=0 /tmp/google-cloud-sdk /usr/local/google-cloud-sdk

# install terraform binaries
ENV NEEDED_TERRAFORM_VERSIONS="0.14.3 0.14.10"
ENV DEFAULT_TERRAFORM_VERSION=0.14.10

RUN apk add --no-cache python3
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

# Install a gsutil symlink
RUN /usr/local/google-cloud-sdk/install.sh
RUN ln -s /usr/local/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil
