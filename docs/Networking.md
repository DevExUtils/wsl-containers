RUN echo -e "[network]\ngenerateResolvConf = false" | sudo tee -a /etc/wsl.conf && \
    sudo unlink /etc/resolv.conf && \
    echo nameserver 1.1.1.1 | sudo tee /etc/resolv.conf