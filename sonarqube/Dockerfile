#
# Sonarqube Dockerfile
#
#

FROM alpine as plugin

RUN apk add --update wget

ENV L10N_ZH_VERSION=1.29

RUN \
    cd /tmp \
    && wget https://github.com/xuhuisheng/sonar-l10n-zh/releases/download/sonar-l10n-zh-plugin-${L10N_ZH_VERSION}/sonar-l10n-zh-plugin-${L10N_ZH_VERSION}.jar

FROM sonarqube:lts

MAINTAINER raw34 <raw34@sina.com>

ENV L10N_ZH_VERSION=1.29

COPY --from=plugin /tmp/sonar-l10n-zh-plugin-${L10N_ZH_VERSION}.jar /opt/sonarqube/extensions/plugins

ENTRYPOINT ["./bin/run.sh"]