# Base image — official Jenkins agent (inbound/JNLP)
# It is capable of connecting to a Jenkins controller and executing pipeline tasks
FROM jenkins/inbound-agent:latest

# Switch to root because jenkins/inbound-agent runs by default 
# to install packages via apt
USER root

# Install dependencies required to add a 
# third-party Docker apt repository:
# - ca-certificates : verifies SSL certificates during downloads
# - curl            : downloads the Docker GPG key
# - gnupg           : handles GPG keys (gpg --dearmor)
# - lsb-release     : identifies the OS version (bookworm, bullseye, etc.)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Download the official Docker GPG key and convert it to binary format
# This allows apt to verify the authenticity of packages from the Docker repository
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the official Docker repository to the apt source list:
# - arch=...        : processor architecture (amd64, arm64, etc.)
# - signed-by=...   : path to the GPG key for package verification
# - bookworm stable : Debian branch and update channel
# 'tee' writes to the file, and '> /dev/null' suppresses console output
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install only the Docker CLI (without the dockerd daemon)
# Full Docker (docker-ce) is not needed because we use the 
# host's Docker socket (/var/run/docker.sock) via volume mount.
# The CLI simply sends commands to the host's daemon.
RUN apt-get update && apt-get install -y \
    docker-ce-cli

# Switch back to the jenkins user for security reasons.
# rather than root
USER jenkins

WORKDIR /home/jenkins

EXPOSE 8000