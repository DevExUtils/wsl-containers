FROM archlinux:base-devel

# Arguments required for base username and password
ARG USERNAME=myuser
ARG TIMEZONE="Europe/Copenhagen"

# Set locals
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TZ > /etc/timezone

COPY ./cert/ZscalerRootCertificate.crt /etc/ca-certificates/trust-source/anchors/ZscalerRootCertificate.crt
RUN sudo update-ca-trust extract

# Update packages and install base packages system wide
RUN pacman -Syu --noprogressbar --noconfirm && \
    pacman -S --needed --noprogressbar --noconfirm \
        pacman-contrib \
        wget \
        git \
        less \
        zsh \
    && paccache -rfk0

# Allow none root user to sudo without password 
RUN chmod 640 /etc/sudoers && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && chmod 440 /etc/sudoers

# Create none root user
RUN useradd -m -g users -G wheel -s /bin/zsh $USERNAME

# Add colors to pacman
RUN sed -i '/Color/s/^#//' /etc/pacman.conf 

# Install Paru as AUR helper
ENV PARU_VERSION=1.11.2
RUN cd ~ && \
    mkdir paru && cd paru && \
    curl -L https://github.com/Morganamilo/paru/releases/download/v${PARU_VERSION}/paru-v${PARU_VERSION}-x86_64.tar.zst -o paru.tar.zst && \
    tar --use-compress-program=unzstd -xvf paru.tar.zst && \
    chmod +x paru && \
    mv paru /usr/local/bin/ && \
    cd ~ && rm -rf paru

# Change ownership of Paru to user
RUN chmod 4711 /usr/local/bin/paru && \
    chown $USERNAME /usr/local/bin/paru

# Copy settings file into user home directory
COPY --chown=$USERNAME:users ./settings/ /home/$USERNAME/

# Copy pem for AWS CLI
COPY --chown=$USERNAME:users ./cert/cacert.pem /home/$USERNAME/.config/ca_certificates/cacert.pem

# Add WSLU utility to pacman package manager repositories.
COPY ./config/wslu.conf /home/$USERNAME/wslu.conf
RUN cd /home/$USERNAME && \
    pacman-key --init && \
    pacman-key -r A2861ABFD897DD37 && \
    wget https://pkg.wslutiliti.es/public.key && \
    pacman-key --add public.key && \
    pacman-key --lsign-key A2861ABFD897DD37 && \
    cat /home/$USERNAME/wslu.conf >> /etc/pacman.conf && \
    rm /home/$USERNAME/wslu.conf && rm /home/$USERNAME/public.key && \
    pacman -Syu

# Add wsl.conf to ensure WSL and other proccesses starts the WSL distribution with your own user instead of root
# Alternative printf "\n[user]\ndefault = myusername\n" | sudo tee -a /etc/wsl.conf

COPY ./config/wsl.conf /etc/wsl.conf
RUN sed -i "s/myuser/$USERNAME/g" /etc/wsl.conf

# Potential network fix
# echo -e "[network]\ngenerateResolvConf = false" | sudo tee -a /etc/wsl.conf
# sudo unlink /etc/resolv.conf
# echo nameserver 1.1.1.1 | sudo tee /etc/resolv.conf
#

# Change to normal user and install applications with Paru
USER $USERNAME
RUN paru -Syu --noconfirm \
        python \
        pyenv \
        nodejs \
        fnm-bin \
        pnpm-bin \
        npm \
        powershell-bin \
        aws-cli-v2 \
        fzf \
        zoxide \
        git-delta \
        neovim \
        terraform \
        ripgrep \
        jq \
        fd \
        exa \
        bat \
        zip \
        github-cli \
        procs \
        onefetch \
        wslu \
        reflector \
        rsync \
        # git-interactive-rebase-tool \
        starship && \
    paccache -rfk0


# installing npx sudo npm install -g npm

# Install python based tools
ENV PATH="/home/$USERNAME/.local/bin:$PATH" 

RUN python -m ensurepip --upgrade && \
    python -m pip install --upgrade pip && \
    python -m pip install pipx

RUN pipx install poetry && \
    pipx install cfn-lint && \
    pipx install pre-commit && \
    pipx install aws-sso-util && \
    pipx install thefuck

#RUN reflector -c Denmark,Germany,Sweden, --fastest 8
# Fix issue with repository trust:
#RUN git config --global --add safe.directory '*'