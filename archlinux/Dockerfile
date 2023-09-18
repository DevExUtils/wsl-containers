FROM archlinux:base-devel

# Arguments for system username and Chezmoi config options
ARG USERNAME="myuser"
ARG NAME="Firstname Lastname"
ARG EMAIL="user@domain.tld"

# Set locals
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen

# Update packages and install base packages system wide
RUN pacman -Syu --noprogressbar --noconfirm && \
    pacman -S --needed --noprogressbar --noconfirm \
        pacman-contrib \
        git \
        less \
        zsh \
        chezmoi  \
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

# Add WSLU utility to pacman package repositories and the /etc/pacman.conf file.
RUN cd /home/$USERNAME && \
    pacman-key --init && \
    curl -L https://pkg.wslutiliti.es/public.key -o public.key && \
    pacman-key --add public.key && \
    pacman-key --lsign-key 2D4C887EB08424F157151C493DD50AA7E055D853 && \
    printf "\n[wslutilities]\nServer = https://pkg.wslutiliti.es/arch/" | sudo tee -a /etc/pacman.conf && \
    rm /home/$USERNAME/public.key && \
    pacman -Syu

# Adds wsl.conf file to set regular user as default instead of root & enable systemd support
RUN printf "[user]\ndefault=$USERNAME\n\n[boot]\nsystemd=true" | sudo tee -a /etc/wsl.conf

# Change to normal user and install boostrap setup with Chezmoi
USER $USERNAME

# Setup .dotfiles from github via chezmoi
RUN chezmoi init https://github.com/DevExUtils/archlinux-dotfiles.git --promptString "email"="$EMAIL" --promptString "name"="$NAME" --promptBool "work_device"="false" --apply