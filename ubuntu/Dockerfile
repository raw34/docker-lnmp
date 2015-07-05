#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04

MAINTAINER raw34 "raw34@sina.com"

ENV REFRESHED_AT 2015-04-29

# Install.
RUN export DEBIAN_FRONTEND=noninteractive \

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget lrzsz iftop nethogs iotop sysstat ssmtp && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  rm -rf /var/lib/apt/lists/*

#COPY ssmtp.conf /etc/ssmtp/
#COPY revaliases /etc/ssmtp/

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

