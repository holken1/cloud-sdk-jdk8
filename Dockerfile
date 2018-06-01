FROM google/cloud-sdk:latest

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list && \
      apt-get update && \
      apt-get install -y -t jessie-backports openjdk-8-jdk && \
      update-java-alternatives --set java-1.8.0-openjdk-amd64
      