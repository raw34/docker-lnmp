#
# Python Dockerfile
#
# https://github.com/dockerfile/python
#

# Pull base image.
# FROM dockerfile/ubuntu
FROM raw34/ubuntu

MAINTAINER raw34 <raw34@sina.com>

# Install Python.
RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python python-dev python-pip python-virtualenv && \
    rm -rf /var/lib/apt/lists/*

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]
