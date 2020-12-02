FROM theiaide/theia:1.0.0

ARG KIND_VERSION="v0.9.0"
ARG K9S_VERSION="v0.24.1"
ARG HELM_VERSION="v3.4.1"
ARG TERRAFORM_VERSION="0.13.5"
ARG SOPS_VERSION="v3.6.1"
ARG STEP_VERSION="0.15.3"

USER root
RUN \
apk add --no-cache bash curl wget docker zsh git vim openssl unzip gnupg netcat-openbsd jq

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
sed -i 's/docker:x:101:theia/docker:x:998:theia/g' /etc/group && \
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
# SOPS https://github.com/mozilla/sops
wget https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
mv sops-${SOPS_VERSION}.linux /usr/bin/sops && \
chmod +x /usr/bin/sops && \
# STEP https://github.com/smallstep/cli
wget https://github.com/smallstep/cli/releases/download/v${STEP_VERSION}/step_linux_${STEP_VERSION}_amd64.tar.gz && \
tar xzf step_linux_${STEP_VERSION}_amd64.tar.gz && \
mv step_${STEP_VERSION}/bin/step /usr/bin/step && \
rm -rf step_linux_${STEP_VERSION}_amd64.tar.gz

USER theia
