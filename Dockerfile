# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Core Cloud
RUN mkdir /engine

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y shellinabox systemd openssh-server sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set root password
RUN echo 'root:root' | chpasswd

# Add a new user rhsalisu with password Rabiu2004@
RUN useradd -m -p $(openssl passwd -1 Rabiu2004@) -s /bin/bash rhsalisu

# Allow ssh root login and password authentication
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose ports for shellinabox and SSH
EXPOSE 4200 22

# Start shellinabox and SSH
CMD ["/bin/bash", "-c", "/usr/bin/shellinaboxd -t -s '/:LOGIN' && /usr/sbin/sshd -D"]
