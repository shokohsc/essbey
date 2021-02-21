FROM theiaide/theia:1.0.0

ARG KIND_VERSION="v0.10.0"
ARG K9S_VERSION="v0.24.2"
ARG HELM_VERSION="v3.5.2"
ARG TERRAFORM_VERSION="0.14.5"
ARG CHART_TESTING_VERSION="3.3.1"
ARG KUBESEAL_VERSION="v0.15.0"

ENV SEALED_SECRETS_CONTROLLER_NAMESPACE="sealed-secrets"

USER root
RUN \
apk add --no-cache bash curl wget docker zsh git vim openssl unzip gnupg netcat-openbsd jq python3 && \
pip3 install --no-cache --upgrade pip setuptools wheel

USER theia
RUN \
bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
sed -i 's/robbyrussell/xiong-chiamiov-plus/g' /home/theia/.zshrc && \
bash -c "echo 'alias ll=\"ls -lah\"' >> /home/theia/.zshrc" && \
git config --global user.email "shokohsc@gmail.com" && \
git config --global user.name "shokohsc"

USER root
RUN \
apk add --no-cache bash curl wget docker zsh git vim openssl unzip gnupg netcat-openbsd && \
grep -qxF 'docker' /etc/group || addgroup -g 998 docker && \
groups theia |grep docker || addgroup theia docker && \
groups theia |grep root || addgroup theia root && \
sed -i 's/docker:x:101:theia/docker:x:999:theia/g' /etc/group && \
# KIND https://github.com/kubernetes-sigs/kind
wget https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64 && \
chmod +x kind-linux-amd64 && \
mv /home/theia/kind-linux-amd64 /usr/bin/kind && \
# KUBECTL https://kubernetes.io/docs/tasks/tools/install-kubectl/
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv /home/theia/kubectl /usr/bin/kubectl && \
# K9S https://github.com/derailed/k9s
wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
tar xzf k9s_Linux_x86_64.tar.gz && \
rm k9s_Linux_x86_64.tar.gz && \
mv /home/theia/k9s /usr/bin/k9s && \
bash -c "grep xterm-256color /home/theia/.zshrc || echo 'export TERM=xterm-256color' >> /home/theia/.zshrc" && \
# HELM https://helm.sh/
wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
tar zxf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
rm helm-${HELM_VERSION}-linux-amd64.tar.gz && \
mv linux-amd64/helm /usr/bin/helm && \
rm -rf linux-amd64 && \
# TERRAFORM https://www.terraform.io/
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
mv terraform /usr/bin/terraform && \
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
# CHART TESTING https://github.com/helm/chart-testing/
pip install yamllint yamale && \
wget https://github.com/helm/chart-testing/releases/download/v${CHART_TESTING_VERSION}/chart-testing_${CHART_TESTING_VERSION}_linux_amd64.tar.gz && \
tar xzf chart-testing_${CHART_TESTING_VERSION}_linux_amd64.tar.gz && \
mv ct /usr/bin/ct && \
rm chart-testing_${CHART_TESTING_VERSION}_linux_amd64.tar.gz LICENSE README.md && \
# KUBESEAL https://github.com/bitnami-labs/sealed-secrets/
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/${KUBESEAL_VERSION}/kubeseal-linux-amd64 -O kubeseal && \
install -m 755 kubeseal /usr/bin/kubeseal

USER theia
