FROM ubuntu
MAINTAINER raw34 "raw34@sina.com"

ENV REFRESHED_AT 2015-04-29

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get update \
&& apt-get -y upgrade \
&& apt-get -y install lrzsz vim htop iftop nethogs iotop sysstat ssmtp wget curl \
&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#COPY ssmtp.conf /etc/ssmtp/
#COPY revaliases /etc/ssmtp/


