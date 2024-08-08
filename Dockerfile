FROM debian:bullseye-slim

ARG TERRAFORM_VERSION=1.9.3
ARG ANSIBLE_VERSION=10.2.0

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    gnupg \
    unzip \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    awscli \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.10 get-pip.py \
    && rm get-pip.py

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl -L -o /usr/local/bin/opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static \
    && chmod 755 /usr/local/bin/opa

RUN pip3 install --no-cache-dir ansible==${ANSIBLE_VERSION}

RUN curl -s https://keybase.io/docs/server_security/code_signing_key.asc | gpg --import \
    && curl -O https://prerelease.keybase.io/keybase_amd64.deb \
    && dpkg -i keybase_amd64.deb \
    && apt-get install -f \
    && rm keybase_amd64.deb

COPY kado /usr/local/bin/kado

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /workspace

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/usr/local/bin/kado"]
